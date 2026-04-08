<script>
	let seriesList = [
		{
			id: 1,
			nom: 'Série Printemps',
			type: 'OD',
			classe: 'Laser',
			nombreCourses: 6,
			nombreComptabilisees: 4,
			description: 'Série de début de saison pour les Laser.'
		},
		{
			id: 2,
			nom: 'Série Open Handicap',
			type: 'H',
			classe: 'Open Handicap',
			nombreCourses: 8,
			nombreComptabilisees: 5,
			description: 'Série ouverte à plusieurs classes avec handicap.'
		},
		{
			id: 3,
			nom: 'Série Été 420',
			type: 'OD',
			classe: '420',
			nombreCourses: 10,
			nombreComptabilisees: 7,
			description: 'Série estivale réservée à la classe 420.'
		}
	];

	let selectedSerie = { ...seriesList[0] };
	let selectedIndex = 0;
	let editMode = false;
	let createMode = false;

	function selectSerie(serie, index) {
		selectedSerie = { ...serie };
		selectedIndex = index;
		editMode = false;
		createMode = false;
	}

	function toggleEdit() {
		if (createMode) return;

		editMode = !editMode;

		if (!editMode) {
			selectedSerie = { ...seriesList[selectedIndex] };
		}
	}

	function saveChanges() {
		seriesList[selectedIndex] = { ...selectedSerie };
		seriesList = [...seriesList];
		editMode = false;
	}

	function startCreateSerie() {
		createMode = true;
		editMode = false;

		selectedSerie = {
			id: null,
			nom: '',
			type: 'OD',
			classe: '',
			nombreCourses: 2,
			nombreComptabilisees: 1,
			description: ''
		};
	}

	function cancelCreate() {
		createMode = false;
		selectedSerie = { ...seriesList[selectedIndex] };
	}

	function createSerie() {
		const newSerie = {
			...selectedSerie,
			id: seriesList.length ? Math.max(...seriesList.map((s) => s.id)) + 1 : 1
		};

		seriesList = [...seriesList, newSerie];
		selectedIndex = seriesList.length - 1;
		selectedSerie = { ...newSerie };
		createMode = false;
	}
</script>

<svelte:head>
	<title>Séries - YRR</title>
</svelte:head>

<div class="page">
	<div class="left-panel">
		<div class="left-header">
			<h1>Liste des séries</h1>
			<button class="create-button" on:click={startCreateSerie}>
				Créer une série
			</button>
		</div>

		{#each seriesList as serie, index}
			<button
				class:selected={selectedIndex === index && !createMode}
				class="serie-button"
				on:click={() => selectSerie(serie, index)}
			>
				<strong>{serie.nom}</strong>
				<span>{serie.classe}</span>
			</button>
		{/each}
	</div>

	<div class="right-panel">
		<div class="header-row">
			<h2>{createMode ? 'Créer une série' : 'Détails de la série'}</h2>

			{#if !createMode}
				<button class="edit-button" on:click={toggleEdit}>
					{editMode ? 'Annuler la modification' : 'Modifier'}
				</button>
			{/if}
		</div>

		{#if selectedSerie}
			<div class="details-card">
				<label>
					<strong>Nom :</strong>
					<input bind:value={selectedSerie.nom} disabled={!editMode && !createMode} />
				</label>

				<label>
					<strong>Type :</strong>
					<select bind:value={selectedSerie.type} disabled={!editMode && !createMode}>
						<option value="OD">OD</option>
						<option value="H">H</option>
					</select>
				</label>

				<label>
					<strong>Classe :</strong>
					<input bind:value={selectedSerie.classe} disabled={!editMode && !createMode} />
				</label>

				<label>
					<strong>Nombre de courses :</strong>
					<input
						type="number"
						min="2"
						bind:value={selectedSerie.nombreCourses}
						disabled={!editMode && !createMode}
					/>
				</label>

				<label>
					<strong>Nombre de courses comptabilisées :</strong>
					<input
						type="number"
						min="1"
						bind:value={selectedSerie.nombreComptabilisees}
						disabled={!editMode && !createMode}
					/>
				</label>

				<label>
					<strong>Description :</strong>
					<textarea
						bind:value={selectedSerie.description}
						disabled={!editMode && !createMode}
					></textarea>
				</label>

				{#if editMode}
					<button class="save-button" on:click={saveChanges}>
						Enregistrer
					</button>
				{/if}

				{#if createMode}
					<div class="create-actions">
						<button class="save-button" on:click={createSerie}>
							Créer
						</button>
						<button class="cancel-button" on:click={cancelCreate}>
							Annuler
						</button>
					</div>
				{/if}
			</div>
		{:else}
			<p>Aucune série sélectionnée.</p>
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

	.serie-button {
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

	.serie-button:hover {
		background: #f0f0f0;
	}

	.serie-button.selected {
		background: #dfe9f3;
		border-color: #7a9bbd;
	}

	.serie-button span {
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
	select,
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
	select:disabled,
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