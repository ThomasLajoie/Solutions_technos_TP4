<script>
	let courses = [
		{
			id: 1,
			nom: 'Course 1',
			type: 'OD',
			classe: 'Laser',
			date: '2026-04-05',
			heureDepart: '10:00',
			parcours: 'Parcours A',
			description: 'Course monotype pour bateaux Laser.'
		},
		{
			id: 2,
			nom: 'Course 2',
			type: 'H',
			classe: 'Open Handicap',
			date: '2026-04-12',
			heureDepart: '14:30',
			parcours: 'Parcours B',
			description: 'Course à handicap regroupant plusieurs classes.'
		},
		{
			id: 3,
			nom: 'Course 3',
			type: 'OD',
			classe: '420',
			date: '2026-04-19',
			heureDepart: '09:15',
			parcours: 'Parcours C',
			description: 'Course de série pour la classe 420.'
		}
	];

	let selectedCourse = { ...courses[0] };
	let selectedIndex = 0;
	let editMode = false;
	let createMode = false;

	function selectCourse(course, index) {
		selectedCourse = { ...course };
		selectedIndex = index;
		editMode = false;
		createMode = false;
	}

	function toggleEdit() {
		if (createMode) return;

		editMode = !editMode;

		if (!editMode) {
			selectedCourse = { ...courses[selectedIndex] };
		}
	}

	function startCreateCourse() {
		createMode = true;
		editMode = false;

		selectedCourse = {
			id: null,
			nom: '',
			type: 'OD',
			classe: '',
			date: '',
			heureDepart: '',
			parcours: '',
			description: ''
		};
	}

	function cancelCreate() {
		createMode = false;
		selectedCourse = { ...courses[selectedIndex] };
	}

	function saveChanges() {
		courses[selectedIndex] = { ...selectedCourse };
		courses = [...courses];
		editMode = false;
	}

	function createCourse() {
		const newCourse = {
			...selectedCourse,
			id: courses.length ? Math.max(...courses.map((c) => c.id)) + 1 : 1
		};

		courses = [...courses, newCourse];
		selectedIndex = courses.length - 1;
		selectedCourse = { ...newCourse };
		createMode = false;
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

		{#each courses as course, index}
			<button
				class:selected={selectedIndex === index && !createMode}
				class="course-button"
				on:click={() => selectCourse(course, index)}
			>
				<strong>{course.nom}</strong>
				<span>{course.date}</span>
			</button>
		{/each}
	</div>

	<div class="right-panel">
		<div class="header-row">
			<h2>{createMode ? 'Créer une course' : 'Détails de la course'}</h2>

			{#if !createMode}
				<button class="edit-button" on:click={toggleEdit}>
					{editMode ? 'Annuler la modification' : 'Modifier'}
				</button>
			{/if}
		</div>

		{#if selectedCourse}
			<div class="details-card">
				<label>
					<strong>Nom :</strong>
					<input bind:value={selectedCourse.nom} disabled={!editMode && !createMode} />
				</label>

				<label>
					<strong>Type :</strong>
					<input bind:value={selectedCourse.type} disabled={!editMode && !createMode} />
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

	h1,
	h2 {
		margin-top: 0;
	}

	.left-header,
	.header-row {
		display: flex;
		justify-content: space-between;
		align-items: center;
		margin-bottom: 20px;
		gap: 10px;
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

	.course-button span {
		font-size: 0.9rem;
		color: #666;
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
	textarea {
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
	textarea:disabled {
		background: #f3f3f3;
		color: #555;
	}

	.edit-button,
	.save-button,
	.create-button,
	.cancel-button {
		padding: 10px 14px;
		border: none;
		border-radius: 6px;
		background: #6f6f6f;
		color: white;
		cursor: pointer;
	}

	.edit-button:hover,
	.save-button:hover,
	.create-button:hover,
	.cancel-button:hover {
		background: #5d5d5d;
	}

	.create-actions {
		display: flex;
		gap: 12px;
	}
</style>