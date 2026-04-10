<script>
import {onMount} from 'svelte';

onMount(async () => {
	try {
		const res = await fetch('http://localhost:4000/api/getraces');
		const data = await res.json();

		courses = data.map(r => ({
	id: r._id.$oid || r._id, 
	nom: r.name,
	parcours: r.location,
	date: r.date,
	type: 'OD',
	classe: '',
	heureDepart: '',
	description: '',
	terminee: false,
	resultats: []
}));

		if (courses.length > 0) {
			selectCourse(courses[0]);
		}
	} catch (e) {
		console.error('Erreur chargement courses', e);
	}
});

	let courses = [];

	let selectedCourse = { ...courses[0] };
	let selectedIndex = 0;
	let editMode = false;
	let createMode = false;
	let resultMode = false;
	let filter = 'all'; // all | active | finished


	function findRealIndex(courseId) {
		return courses.findIndex((course) => course.id === courseId);
	}

	function selectCourse(course) {
		selectedCourse = structuredClone(course);
		selectedIndex = findRealIndex(course.id);
		editMode = false;
		createMode = false;
		resultMode = false;
	}

	function toggleEdit() {
		if (createMode || resultMode) return;

		editMode = !editMode;

		if (!editMode) {
			selectedCourse = structuredClone(courses[selectedIndex]);
		}
	}

	function startCreateCourse() {
		createMode = true;
		editMode = false;
		resultMode = false;

		selectedCourse = {
			id: null,
			nom: '',
			type: 'OD',
			classe: '',
			date: '',
			heureDepart: '',
			parcours: '',
			description: '',
			terminee: false,
			resultats: []
		};
	}

	function cancelCreate() {
		createMode = false;
		selectedCourse = structuredClone(courses[selectedIndex]);
	}

	function saveChanges() {
		courses[selectedIndex] = structuredClone(selectedCourse);
		courses = [...courses];
		selectedCourse = structuredClone(courses[selectedIndex]);
		editMode = false;
	}

	async function createCourse() {
	try {
		const payload = {
			name: selectedCourse.nom,
			location: selectedCourse.parcours || "Non défini",
			date: selectedCourse.date
		};

		const response = await fetch('http://localhost:4000/api/addrace', {
			method: 'POST',
			headers: {
				'Content-Type': 'application/json'
			},
			body: JSON.stringify(payload)
		});

		if (!response.ok) {
			throw new Error('Erreur lors de la création de la course');
		}

		const result = await response.json();

		const newCourse = {
	...structuredClone(selectedCourse),
	id: result.id.$oid || result.id,
	terminee: false
};

		courses = [...courses, newCourse];
		selectedIndex = courses.length - 1;
		selectedCourse = structuredClone(newCourse);
		createMode = false;

		console.log('Course créée en DB:', result);

	} catch (error) {
		const text = await response.text();
	console.error('Erreur API:', text);
	alert(text);
	}
}

	function toggleResultsMode() {
		if (createMode || editMode) return;

		resultMode = !resultMode;

		if (!resultMode) {
			selectedCourse = structuredClone(courses[selectedIndex]);
		}
	}

	function saveResults() {
		if (selectedCourse.type === 'OD') {
			recalculateODPositions();
		}

		courses[selectedIndex] = structuredClone(selectedCourse);
		courses = [...courses];
		selectedCourse = structuredClone(courses[selectedIndex]);
		resultMode = false;
	}

	function recalculateODPositions() {
		const valides = selectedCourse.resultats
			.filter((r) => r.resultat !== '' && !isNaN(Number(r.resultat)))
			.sort((a, b) => Number(a.resultat) - Number(b.resultat));

		for (const participant of selectedCourse.resultats) {
			participant.position = null;
		}

		valides.forEach((participant, index) => {
			participant.position = index + 1;
		});
	}

	function markFinished() {
		if (selectedCourse.type === 'OD') {
			recalculateODPositions();
		}

		selectedCourse.terminee = true;
		courses[selectedIndex] = structuredClone(selectedCourse);
		courses = [...courses];
		selectedCourse = structuredClone(courses[selectedIndex]);
		resultMode = false;
		editMode = false;
	}

	function reopenCourse() {
		selectedCourse.terminee = false;
		courses[selectedIndex] = structuredClone(selectedCourse);
		courses = [...courses];
		selectedCourse = structuredClone(courses[selectedIndex]);
	}

	function getPodium(course) {
		if (!course?.resultats) return [];

		return [...course.resultats]
			.filter((r) => r.position !== null && r.position !== undefined)
			.sort((a, b) => a.position - b.position)
			.slice(0, 3);
	}
</script>

<svelte:head>
	<title>Courses - YRR</title>
</svelte:head>

<div class="page">
	<div class="left-panel">
		<div class="left-header">
			<h1>Liste des courses</h1>
			<button class="create-button" on:click={startCreateCourse}>
				Créer une course
			</button>
		</div>

		{#each courses as course}
			<button
				class:selected={selectedCourse.id === course.id && !createMode}
				class="course-button"
				on:click={() => selectCourse(course)}
			>
				<div class="course-top-row">
					<strong>{course.nom}</strong>
					<span class:status-finished={course.terminee} class:status-active={!course.terminee} class="status-badge">
						{course.terminee ? 'Terminée' : 'En cours'}
					</span>
				</div>
				<span>{course.date}</span>
				<small>{course.classe}</small>
			</button>
		{/each}
	</div>

	<div class="right-panel">
		<div class="header-row">
			<h2>
				{#if createMode}
					Créer une course
				{:else}
					Détails de la course
				{/if}
			</h2>

			{#if !createMode}
				<div class="header-actions">
					<button class="secondary-button" on:click={toggleResultsMode}>
						{resultMode ? 'Annuler résultats' : 'Entrer / modifier les résultats'}
					</button>

					<button class="edit-button" on:click={toggleEdit} disabled={resultMode}>
						{editMode ? 'Annuler la modification' : 'Modifier'}
					</button>
				</div>
			{/if}
		</div>

		{#if selectedCourse}
			<div class="details-card">
				<div class="summary-banner">
					<div>
						<strong>État :</strong>
						<span class:status-finished={selectedCourse.terminee} class:status-active={!selectedCourse.terminee} class="status-badge inline-badge">
							{selectedCourse.terminee ? 'Course terminée' : 'Course non terminée'}
						</span>
					</div>

					<div class="course-lock-note">
						{#if selectedCourse.terminee}
							Participants verrouillés, résultats modifiables.
						{:else}
							Participants modifiables, résultats à saisir après la course.
						{/if}
					</div>
				</div>

				<label>
					<strong>Nom :</strong>
					<input bind:value={selectedCourse.nom} disabled={!editMode && !createMode} />
				</label>

				<label>
					<strong>Type :</strong>
					<select bind:value={selectedCourse.type} disabled={!editMode && !createMode}>
						<option value="OD">OD</option>
						<option value="H">H</option>
					</select>
				</label>

				<label>
					<strong>Classe :</strong>
					<input bind:value={selectedCourse.classe} disabled={!editMode && !createMode} />
				</label>

				<label>
					<strong>Date :</strong>
					<input bind:value={selectedCourse.date} disabled={!editMode && !createMode} />
				</label>

				<label>
					<strong>Heure de départ :</strong>
					<input bind:value={selectedCourse.heureDepart} disabled={!editMode && !createMode} />
				</label>

				<label>
					<strong>Parcours :</strong>
					<input bind:value={selectedCourse.parcours} disabled={!editMode && !createMode} />
				</label>

				<label>
					<strong>Description :</strong>
					<textarea bind:value={selectedCourse.description} disabled={!editMode && !createMode}></textarea>
				</label>

				{#if !createMode}
					<div class="info-box">
						<strong>Gestion des participants :</strong>
						{#if selectedCourse.terminee}
							Cette course est terminée. L’ajout de participants doit être bloqué dans la page Inscriptions.
						{:else}
							Cette course est encore ouverte. On peut encore y ajouter des participants.
						{/if}
					</div>
				{/if}

				{#if editMode}
					<button class="save-button" on:click={saveChanges}>
						Enregistrer
					</button>
				{/if}

				{#if createMode}
					<div class="create-actions">
						<button class="save-button" on:click={createCourse}>
							Créer
						</button>
						<button class="cancel-button" on:click={cancelCreate}>
							Annuler
						</button>
					</div>
				{/if}

				{#if !createMode}
					<div class="results-section">
						<div class="results-header">
							<h3>Résultats</h3>

							<div class="results-actions">
								{#if !selectedCourse.terminee}
									<button class="finish-button" on:click={markFinished}>
										Marquer comme terminée
									</button>
								{:else}
									<button class="reopen-button" on:click={reopenCourse}>
										Rouvrir la course
									</button>
								{/if}
							</div>
						</div>

						<div class="podium-box">
							<h4>Podium</h4>
							{#if getPodium(selectedCourse).length > 0}
								<ol>
									{#each getPodium(selectedCourse) as participant}
										<li>{participant.bateau}</li>
									{/each}
								</ol>
							{:else}
								<p>Aucun classement disponible pour le moment.</p>
							{/if}
						</div>

						{#if resultMode}
							<div class="results-edit-box">
								<h4>Saisie / modification des résultats</h4>

								<table>
									<thead>
										<tr>
											<th>Bateau</th>
											<th>Résultat saisi</th>
											<th>Position</th>
										</tr>
									</thead>
									<tbody>
										{#each selectedCourse.resultats as participant}
											<tr>
												<td>{participant.bateau}</td>
												<td>
													<input
														bind:value={participant.resultat}
														placeholder={selectedCourse.type === 'OD' ? '1, 2, 3 ou DNF' : 'HH:MM:SS ou DNF'}
													/>
												</td>
												<td>{participant.position ?? '-'}</td>
											</tr>
										{/each}
									</tbody>
								</table>

								<div class="create-actions">
									<button class="save-button" on:click={saveResults}>
										Enregistrer les résultats
									</button>
								</div>
							</div>
						{:else}
							<div class="results-view-box">
								<table>
									<thead>
										<tr>
											<th>Bateau</th>
											<th>Résultat</th>
											<th>Position</th>
										</tr>
									</thead>
									<tbody>
										{#each selectedCourse.resultats as participant}
											<tr>
												<td>{participant.bateau}</td>
												<td>{participant.resultat || '-'}</td>
												<td>{participant.position ?? '-'}</td>
											</tr>
										{/each}
									</tbody>
								</table>
							</div>
						{/if}
					</div>
				{/if}
			</div>
		{:else}
			<p>Aucune course sélectionnée.</p>
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
		grid-template-columns: 340px 1fr;
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

	h1,
	h2,
	h3,
	h4 {
		margin-top: 0;
	}

	.left-header,
	.header-row,
	.results-header {
		display: flex;
		justify-content: space-between;
		align-items: center;
		margin-bottom: 20px;
		gap: 10px;
	}

	.header-actions,
	.results-actions,
	.create-actions {
		display: flex;
		gap: 12px;
		flex-wrap: wrap;
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

	.course-top-row {
		display: flex;
		justify-content: space-between;
		align-items: center;
		gap: 8px;
	}

	.course-button span,
	.course-button small {
		font-size: 0.9rem;
		color: #666;
	}

	.status-badge {
		font-size: 0.75rem;
		padding: 4px 8px;
		border-radius: 999px;
		font-weight: bold;
	}

	.status-active {
		background: #e6f6ea;
		color: #1e7a38;
	}

	.status-finished {
		background: #ececec;
		color: #555;
	}

	.inline-badge {
		margin-left: 8px;
	}

	.summary-banner,
	.info-box,
	.podium-box,
	.results-edit-box,
	.results-view-box {
		background: #fafafa;
		border: 1px solid #e3e3e3;
		border-radius: 8px;
		padding: 16px;
	}

	.summary-banner {
		display: flex;
		justify-content: space-between;
		align-items: center;
		gap: 12px;
		flex-wrap: wrap;
	}

	.course-lock-note {
		color: #666;
		font-size: 0.95rem;
	}

	.details-card {
		display: flex;
		flex-direction: column;
		gap: 14px;
	}

	label {
		display: flex;
		flex-direction: column;
		gap: 6px;
	}

	input,
	textarea,
	select {
		padding: 10px;
		border: 1px solid #ccc;
		border-radius: 6px;
		font-size: 1rem;
		box-sizing: border-box;
	}

	textarea {
		min-height: 90px;
		resize: vertical;
	}

	input:disabled,
	textarea:disabled,
	select:disabled {
		background: #f3f3f3;
		color: #555;
	}

	.results-section {
		margin-top: 10px;
		display: flex;
		flex-direction: column;
		gap: 16px;
	}

	table {
		width: 100%;
		border-collapse: collapse;
		background: white;
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

	.edit-button,
	.save-button,
	.create-button,
	.cancel-button,
	.secondary-button,
	.finish-button,
	.reopen-button {
		padding: 10px 14px;
		border: none;
		border-radius: 6px;
		background: #6f6f6f;
		color: white;
		cursor: pointer;
	}

	.secondary-button {
		background: #4f78a8;
	}

	.finish-button {
		background: #2c8f5a;
	}

	.reopen-button {
		background: #b07a2a;
	}

	.edit-button:hover,
	.save-button:hover,
	.create-button:hover,
	.cancel-button:hover,
	.secondary-button:hover,
	.finish-button:hover,
	.reopen-button:hover {
		filter: brightness(0.95);
	}
</style>