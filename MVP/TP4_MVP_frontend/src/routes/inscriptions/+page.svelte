<script>
	import { onMount } from 'svelte';

	const API_BASE = 'http://localhost:4000/api';

	let courses = [];
	let bateaux = [];
	let participants = [];

	let selectedCourse = null;
	let mode = 'voir';
	let bateauxSelectionnes = [];

	let loadingCourses = false;
	let loadingBoats = false;
	let loadingParticipants = false;
	let submitting = false;
	let errorMessage = '';

	onMount(async () => {
		await Promise.all([chargerCourses(), chargerBateaux()]);
	});

	async function chargerCourses() {
		loadingCourses = true;
		errorMessage = '';

		try {
			const response = await fetch(`${API_BASE}/getraces`);
			if (!response.ok) throw new Error('Impossible de charger les courses');

			const data = await response.json();

			courses = data.map(mapRaceFromApi);

			if (courses.length > 0 && !selectedCourse) {
				selectedCourse = courses[0];
				await chargerParticipants(selectedCourse.id);
			}
		} catch (error) {
			console.error(error);
			errorMessage = error.message || 'Erreur lors du chargement des courses';
		} finally {
			loadingCourses = false;
		}
	}

	async function chargerBateaux() {
		loadingBoats = true;
		errorMessage = '';

		try {
			const response = await fetch(`${API_BASE}/getboats`);
			if (!response.ok) throw new Error('Impossible de charger les bateaux');

			const data = await response.json();
			bateaux = data.map(mapBoatFromApi);
		} catch (error) {
			console.error(error);
			errorMessage = error.message || 'Erreur lors du chargement des bateaux';
		} finally {
			loadingBoats = false;
		}
	}

	async function chargerParticipants(courseId) {
		if (!courseId) return;

		loadingParticipants = true;
		errorMessage = '';

		try {
			const response = await fetch(`${API_BASE}/getparticipantsforrace/${courseId}`);
			if (!response.ok) {
				const err = await response.json().catch(() => ({}));
				throw new Error(err.error || 'Impossible de charger les participants');
			}

			const data = await response.json();
			participants = data.map(mapParticipantFromApi);
		} catch (error) {
			console.error(error);
			errorMessage = error.message || 'Erreur lors du chargement des participants';
			participants = [];
		} finally {
			loadingParticipants = false;
		}
	}

	function mapRaceFromApi(race) {
		return {
			id: race._id?.$oid ?? race.id ?? race._id,
			nom: race.name ?? '',
			date: race.date ?? '',
			classe: race.class ?? race.location ?? '',
			terminee: race.finished ?? false
		};
	}

	function mapBoatFromApi(boat) {
		return {
			id: boat._id?.$oid ?? boat.id ?? boat._id,
			nom: boat.name ?? boat.nom ?? '',
			numeroVoile: String(boat.sail_number ?? boat.numeroVoile ?? boat.noVoile ?? ''),
			classe: boat.class ?? boat.classe ?? '',
			barreur: boat.helm_name ?? boat.barreur ?? boat.NomBarreur ?? ''
		};
	}

	function mapParticipantFromApi(participant) {
		return {
			id: participant.id ?? participant.boat_id,
			boatId: participant.boat_id,
			nom: participant.boat_name ?? '',
			numeroVoile: String(participant.sail_number ?? ''),
			classe: participant.boat_class ?? '',
			barreur: participant.helm_name ?? ''
		};
	}

	async function selectCourse(course) {
		selectedCourse = course;
		mode = 'voir';
		bateauxSelectionnes = [];
		await chargerParticipants(course.id);
	}

	function getParticipants() {
		return participants;
	}

	function getBateauxDisponibles() {
		const dejaInscrits = new Set(participants.map((p) => String(p.boatId ?? p.id)));
		return bateaux.filter((b) => !dejaInscrits.has(String(b.id)));
	}

	function toggleBoatSelection(boatId) {
		if (bateauxSelectionnes.includes(boatId)) {
			bateauxSelectionnes = bateauxSelectionnes.filter((id) => id !== boatId);
		} else {
			bateauxSelectionnes = [...bateauxSelectionnes, boatId];
		}
	}

	async function ajouterParticipants() {
		if (!selectedCourse) return;

		if (selectedCourse.terminee) {
			alert('Cette course est terminée. Impossible d’ajouter des participants.');
			return;
		}

		submitting = true;
		errorMessage = '';

		try {
			for (const boatId of bateauxSelectionnes) {
				const bateau = bateaux.find((b) => String(b.id) === String(boatId));
				if (!bateau) continue;

				const payload = {
					race_id: String(selectedCourse.id),
					boat_id: String(bateau.id),
					boat_name: bateau.nom,
					sail_number: String(bateau.numeroVoile),
					boat_class: bateau.classe,
					helm_name: bateau.barreur
				};

				const response = await fetch(`${API_BASE}/addparticipanttorace`, {
					method: 'POST',
					headers: {
						'Content-Type': 'application/json'
					},
					body: JSON.stringify(payload)
				});

				if (!response.ok) {
					const err = await response.json().catch(() => ({}));
					throw new Error(err.error || 'Erreur lors de l’ajout des participants');
				}
			}

			bateauxSelectionnes = [];
			mode = 'voir';
			await chargerParticipants(selectedCourse.id);
			await chargerCourses();
		} catch (error) {
			console.error(error);
			errorMessage = error.message || 'Erreur lors de l’ajout des participants';
			alert(errorMessage);
		} finally {
			submitting = false;
		}
	}
</script>

<svelte:head>
	<title>Inscriptions - YRR</title>
</svelte:head>

<div class="page">
	<div class="left-panel">
		<h1>Courses</h1>

		{#if loadingCourses}
			<p>Chargement des courses...</p>
		{:else if courses.length === 0}
			<p>Aucune course disponible.</p>
		{:else}
			{#each courses as course}
				<button
					class:selected={selectedCourse?.id === course.id}
					class="course-button"
					on:click={() => selectCourse(course)}
				>
					<div class="course-top">
						<strong>{course.nom}</strong>
						<span
							class:badge-finished={course.terminee}
							class:badge-active={!course.terminee}
							class="status-badge"
						>
							{course.terminee ? 'Terminée' : 'En cours'}
						</span>
					</div>
					<span>{course.date}</span>
					<small>{course.classe}</small>
				</button>
			{/each}
		{/if}
	</div>

	<div class="right-panel">
		{#if selectedCourse}
			<h2>Participants - {selectedCourse.nom}</h2>
			<p class="subtitle">
				Date : {selectedCourse.date} | Classe : {selectedCourse.classe}
			</p>

			{#if selectedCourse.terminee}
				<div class="warning-box">
					Cette course est terminée. Les participants sont visibles, mais on ne peut plus en ajouter.
				</div>
			{/if}

			{#if errorMessage}
				<div class="error-box">{errorMessage}</div>
			{/if}

			<div class="top-actions">
				<button class:active={mode === 'voir'} class="top-button" on:click={() => (mode = 'voir')}>
					Voir les participants
				</button>

				<button
					class:active={mode === 'ajouter'}
					class="top-button"
					on:click={() => (mode = 'ajouter')}
					disabled={selectedCourse.terminee}
				>
					Ajouter des bateaux
				</button>
			</div>

			{#if mode === 'voir'}
				<div class="content-box">
					<h3>Participants inscrits</h3>

					{#if loadingParticipants}
						<p>Chargement des participants...</p>
					{:else if getParticipants().length > 0}
						<table>
							<thead>
								<tr>
									<th>Nom du bateau</th>
									<th>No voile</th>
									<th>Classe</th>
									<th>Barreur</th>
								</tr>
							</thead>
							<tbody>
								{#each getParticipants() as bateau}
									<tr>
										<td>{bateau.nom}</td>
										<td>{bateau.numeroVoile}</td>
										<td>{bateau.classe}</td>
										<td>{bateau.barreur}</td>
									</tr>
								{/each}
							</tbody>
						</table>
					{:else}
						<p>Aucun participant inscrit à cette course.</p>
					{/if}
				</div>
			{/if}

			{#if mode === 'ajouter'}
				<div class="content-box">
					<h3>Ajouter un ou plusieurs bateaux</h3>

					{#if loadingBoats}
						<p>Chargement des bateaux...</p>
					{:else if getBateauxDisponibles().length > 0}
						<div class="boat-list">
							{#each getBateauxDisponibles() as bateau}
								<label class="boat-item">
									<input
										type="checkbox"
										checked={bateauxSelectionnes.includes(bateau.id)}
										on:change={() => toggleBoatSelection(bateau.id)}
									/>
									<div>
										<strong>{bateau.nom}</strong>
										<div>No voile : {bateau.numeroVoile}</div>
										<div>Classe : {bateau.classe}</div>
										<div>Barreur : {bateau.barreur}</div>
									</div>
								</label>
							{/each}
						</div>

						<button
							class="submit-button"
							on:click={ajouterParticipants}
							disabled={bateauxSelectionnes.length === 0 || submitting}
						>
							{submitting ? 'Ajout en cours...' : 'Ajouter les bateaux sélectionnés'}
						</button>
					{:else}
						<p>Tous les bateaux disponibles sont déjà inscrits à cette course.</p>
					{/if}
				</div>
			{/if}
		{:else}
			<p>Aucune course sélectionnée. Créez au moins une course pour utiliser cette page.</p>
		{/if}
	</div>
</div>

<style>
	:global(body) {
		margin: 0;
		font-family: Arial, sans-serif;
		background: #f4f6f8;
	}

	.page {
		display: grid;
		grid-template-columns: 320px 1fr;
		gap: 24px;
		padding: 24px;
		min-height: 100vh;
		box-sizing: border-box;
	}

	.left-panel,
	.right-panel {
		background: white;
		border-radius: 10px;
		padding: 20px;
		box-shadow: 0 0 10px rgba(0, 0, 0, 0.08);
	}

	h1, h2, h3 {
		margin-top: 0;
	}

	.subtitle {
		color: #666;
		margin-bottom: 20px;
	}

	.course-button {
		width: 100%;
		text-align: left;
		padding: 12px;
		margin-bottom: 10px;
		border: 1px solid #d0d0d0;
		border-radius: 8px;
		background: #fafafa;
		cursor: pointer;
		display: flex;
		flex-direction: column;
		gap: 4px;
	}

	.course-button:hover {
		background: #f0f0f0;
	}

	.course-button.selected {
		background: #dfe9f3;
		border-color: #7a9bbd;
	}

	.course-top {
		display: flex;
		justify-content: space-between;
		align-items: center;
		gap: 8px;
	}

	.status-badge {
		font-size: 0.75rem;
		padding: 4px 8px;
		border-radius: 999px;
		font-weight: bold;
	}

	.badge-active {
		background: #e6f6ea;
		color: #1e7a38;
	}

	.badge-finished {
		background: #ececec;
		color: #555;
	}

	.course-button span,
	.course-button small {
		color: #666;
	}

	.warning-box {
		background: #fff4e5;
		color: #8a5a00;
		border: 1px solid #f0d3a2;
		padding: 12px 14px;
		border-radius: 8px;
		margin-bottom: 16px;
	}

	.error-box {
		background: #fdecec;
		color: #8f1d1d;
		border: 1px solid #f5bcbc;
		padding: 12px 14px;
		border-radius: 8px;
		margin-bottom: 16px;
	}

	.top-actions {
		display: flex;
		gap: 12px;
		margin-bottom: 20px;
	}

	.top-button,
	.submit-button {
		padding: 10px 14px;
		border: none;
		border-radius: 6px;
		background: #6f6f6f;
		color: white;
		cursor: pointer;
	}

	.top-button.active {
		background: #4f78a8;
	}

	.top-button:hover,
	.submit-button:hover {
		background: #5d5d5d;
	}

	.top-button:disabled,
	.submit-button:disabled {
		opacity: 0.5;
		cursor: not-allowed;
	}

	.content-box {
		background: #fafafa;
		border: 1px solid #e0e0e0;
		border-radius: 8px;
		padding: 20px;
	}

	table {
		width: 100%;
		border-collapse: collapse;
		margin-top: 12px;
	}

	th,
	td {
		border: 1px solid #ddd;
		padding: 10px;
		text-align: left;
	}

	th {
		background: #f0f0f0;
	}

	.boat-list {
		display: flex;
		flex-direction: column;
		gap: 12px;
		margin-bottom: 20px;
	}

	.boat-item {
		display: flex;
		gap: 12px;
		align-items: flex-start;
		background: white;
		padding: 12px;
		border: 1px solid #ddd;
		border-radius: 8px;
		cursor: pointer;
	}
</style>