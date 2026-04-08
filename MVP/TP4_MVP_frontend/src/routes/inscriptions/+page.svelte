<script>

	let courses = [
		{ id: 1, nom: 'Course 1', date: '2026-04-05', classe: 'Laser' },
		{ id: 2, nom: 'Course 2', date: '2026-04-12', classe: 'Open Handicap' },
		{ id: 3, nom: 'Course 3', date: '2026-04-19', classe: '420' }

	];
 
	let bateaux = [
		{ id: 1, nom: 'Sea Breeze', numeroVoile: '101', classe: 'Laser', barreur: 'Jean Tremblay' },
		{ id: 2, nom: 'Wind Rider', numeroVoile: '102', classe: 'Laser', barreur: 'Marc Gagnon' },
		{ id: 3, nom: 'Ocean Star', numeroVoile: '220', classe: 'Open Handicap', barreur: 'Sophie Roy' },
		{ id: 4, nom: 'Blue Wave', numeroVoile: '305', classe: '420', barreur: 'Luc Martin' },
		{ id: 5, nom: 'Storm Light', numeroVoile: '306', classe: '420', barreur: 'Julie Bouchard' }

	];
 
	let inscriptionsParCourse = {
		1: [1, 2],
		2: [3],
		3: [4]
	};
 
	let selectedCourse = courses[0];

	let mode = 'voir'; // voir | ajouter

	let bateauxSelectionnes = [];
 
	function selectCourse(course) {

		selectedCourse = course;
		mode = 'voir';
		bateauxSelectionnes = [];
	}
 
	function getParticipants(courseId) {
		const ids = inscriptionsParCourse[courseId] || [];

		return bateaux.filter((b) => ids.includes(b.id));
	}
 
	function getBateauxDisponibles(courseId) {
		const dejaInscrits = inscriptionsParCourse[courseId] || [];

		return bateaux.filter((b) => !dejaInscrits.includes(b.id));
	}
 
	function toggleBoatSelection(boatId) {

		if (bateauxSelectionnes.includes(boatId)) {
			bateauxSelectionnes = bateauxSelectionnes.filter((id) => id !== boatId);

		} else {
			bateauxSelectionnes = [...bateauxSelectionnes, boatId];
		}

	}
 
	async function ajouterParticipants() {
	try {
		const payload = {
			courseId: selectedCourse.id,
			bateaux: bateauxSelectionnes
		};

		const response = await fetch('http://localhost:4000/api/inscriptions', {
			method: 'POST',
			headers: {
				'Content-Type': 'application/json'
			},
			body: JSON.stringify(payload)
		});

		if (!response.ok) {
			throw new Error('Erreur lors de l’ajout des participants');
		}

		const data = await response.json();

		if (!inscriptionsParCourse[selectedCourse.id]) {
			inscriptionsParCourse[selectedCourse.id] = [];
		}

		inscriptionsParCourse[selectedCourse.id] = [
			...inscriptionsParCourse[selectedCourse.id],
			...bateauxSelectionnes
		];

		inscriptionsParCourse = { ...inscriptionsParCourse };
		bateauxSelectionnes = [];
		mode = 'voir';

		console.log('Participants ajoutés:', data);

	} catch (error) {
		console.error(error);
		alert('Erreur lors de l’ajout des participants');
	}
}
 
	async function supprimerParticipant(boatId) {
	try {
		const response = await fetch('http://localhost:4000/api/inscriptions', {
			method: 'DELETE',
			headers: {
				'Content-Type': 'application/json'
			},
			body: JSON.stringify({
				courseId: selectedCourse.id,
				boatId: boatId
			})
		});

		if (!response.ok) {
			throw new Error('Erreur lors de la suppression');
		}

		inscriptionsParCourse[selectedCourse.id] =
			(inscriptionsParCourse[selectedCourse.id] || []).filter((id) => id !== boatId);

		inscriptionsParCourse = { ...inscriptionsParCourse };

	} catch (error) {
		console.error(error);
		alert('Erreur lors de la suppression');
	}
}
</script>
 
<svelte:head>
<title>Inscriptions - YRR</title>
</svelte:head>
 
<div class="page">
<div class="left-panel">
<h1>Courses</h1>
 
		{#each courses as course}
<button

				class:selected={selectedCourse.id === course.id}

				class="course-button"

				on:click={() => selectCourse(course)}
>
<strong>{course.nom}</strong>
<span>{course.date}</span>
<small>{course.classe}</small>
</button>

		{/each}
</div>
 
	<div class="right-panel">
<h2>Participants - {selectedCourse.nom}</h2>
<p class="subtitle">

			Date : {selectedCourse.date} | Classe : {selectedCourse.classe}
</p>
 
		<div class="top-actions">
<button class:active={mode === 'voir'} class="top-button" on:click={() => mode = 'voir'}>

				Voir les participants
</button>
 
			<button class:active={mode === 'ajouter'} class="top-button" on:click={() => mode = 'ajouter'}>

				Ajouter des bateaux
</button>
</div>
 
		{#if mode === 'voir'}
<div class="content-box">
<h3>Participants inscrits</h3>
 
				{#if getParticipants(selectedCourse.id).length > 0}
<table>
<thead>
<tr>
<th>Nom du bateau</th>
<th>No voile</th>
<th>Classe</th>
<th>Barreur</th>
<th>Action</th>
</tr>
</thead>
<tbody>

							{#each getParticipants(selectedCourse.id) as bateau}
<tr>
<td>{bateau.nom}</td>
<td>{bateau.numeroVoile}</td>
<td>{bateau.classe}</td>
<td>{bateau.barreur}</td>
<td>
<button class="delete-button" on:click={() => supprimerParticipant(bateau.id)}>

											Supprimer
</button>
</td>
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
 
				{#if getBateauxDisponibles(selectedCourse.id).length > 0}
<div class="boat-list">

						{#each getBateauxDisponibles(selectedCourse.id) as bateau}
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
 
					<button class="submit-button" on:click={ajouterParticipants} disabled={bateauxSelectionnes.length === 0}>

						Ajouter les bateaux sélectionnés
</button>

				{:else}
<p>Tous les bateaux disponibles sont déjà inscrits à cette course.</p>

				{/if}
</div>

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
 
	.course-button span,

	.course-button small {
		color: #666;
	}
 
	.top-actions {
		display: flex;
		gap: 12px;
		margin-bottom: 20px;
	}
 
	.top-button,

	.submit-button,

	.delete-button {
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

	.submit-button:hover,

	.delete-button:hover {
		background: #5d5d5d;
	}
 
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
 