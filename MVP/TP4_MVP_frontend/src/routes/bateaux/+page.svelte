

<script>
import { onMount } from 'svelte';

let bateaux = [];

   onMount(async () => {
	try {
		const response = await fetch('http://localhost:4000/api/getboats');

		if (!response.ok) {
			throw new Error('Erreur chargement séries');
		}

		const data = await response.json();

		bateaux = data;

	

		console.log('Bateaux chargées:', data);

	} catch (error) {
		console.error(error);
		alert('Erreur lors du chargement des bateaux');
	}
});

let nomBateau = '';
	let numeroVoile = '';
	let classeBateau = '';
	let nomBarreur = '';

async function ajouterBateau() {
	try {
		const response = await fetch('http://localhost:4000/api/addboat', {
			method: 'POST',
			headers: {
				'Content-Type': 'application/json'
			},
			body: JSON.stringify({
				nomBateau,
				numeroVoile,
				classeBateau,
				nomBarreur
			})
		});

		if (!response.ok) {
			throw new Error('Erreur ajout bateau');
		}

		// 🔄 reload liste
		const res = await fetch('http://localhost:4000/api/getboats');
		bateaux = await res.json();

		// reset form
		nomBateau = '';
		numeroVoile = '';
		classeBateau = '';
		nomBarreur = '';

	} catch (error) {
		console.error(error);
		alert('Erreur lors de l’ajout du bateau');
	}
}
</script>

<h2>Ajouter un bateau</h2>

<form on:submit|preventDefault={ajouterBateau}>
    <h2>Informations du bateau</h2>

    <label for="nomBateau">Nom du bateau</label>
	<input type="text" id="nomBateau" bind:value={nomBateau} required />

	<label for="numeroVoile">Numéro de voile</label>
	<input type="text" id="numeroVoile" bind:value={numeroVoile} required />

	<label for="classeBateau">Classe du bateau</label>
	<input type="text" id="classeBateau" bind:value={classeBateau} required />

	<label for="nomBarreur">Nom du barreur</label>
	<input type="text" id="nomBarreur" bind:value={nomBarreur} required />

    <button type="submit">Envoyer</button>

</form>

<h2>Liste des bateaux</h2>

<div class="table-container">
	<table class="boats-table">
		<thead>
			<tr>
				<th>Nom</th>
				<th>Num</th>
				<th>Classe</th>
				<th>Barreur</th>
			</tr>
		</thead>
		<tbody>
			{#each bateaux.reverse() as bateau}
				<tr>
					<td>{bateau.nom}</td>
					<td>{bateau.noVoile}</td>
					<td>{bateau.classe}</td>
					<td>{bateau.NomBarreur}</td>
				</tr>
			{/each}
		</tbody>
	</table>
</div>

<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f4f6f8;
        padding: 20px;
    }
    form {
        background: white;
        padding: 20px;
        max-width: 400px;
        margin: auto;
        border-radius: 8px;
        box-shadow: 0 0 10px rgba(0,0,0,0.1);
    }
    label {
        display: block;
        margin-top: 10px;
    }
    input {
        width: 100%;
        padding: 8px;
        margin-top: 5px;
        border-radius: 4px;
        border: 1px solid #ccc;
        box-sizing: border-box;
    }
    button {
        margin-top: 15px;
        padding: 10px;
        width: 100%;
        background-color: #888888;
        color: white;
        border: none;
        border-radius: 4px;
        cursor: pointer;
    }
    button:hover {
        background-color: #777777;
    }
    .table-container {
    background: white;
    border-radius: 14px;
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
    overflow: hidden;
    border: 1px solid #e6e6e6;
}

.boats-table {
    width: 100%;
    border-collapse: collapse;
    font-family: Arial, sans-serif;
}

.boats-table thead {
    background: linear-gradient(to right, #5f6f82, #7a8da3);
    color: white;
}

.boats-table th {
    text-align: left;
    padding: 14px 16px;
    font-size: 0.95rem;
    letter-spacing: 0.02em;
}

.boats-table td {
    padding: 14px 16px;
    border-top: 1px solid #eeeeee;
    color: #333;
    font-size: 0.95rem;
}

.boats-table tbody tr:nth-child(even) {
    background: #fafbfc;
}

.boats-table tbody tr:hover {
    background: #eef4fa;
    transition: background 0.2s ease;
}

.boats-table td:first-child {
    font-weight: 600;
}

@media (max-width: 700px) {
    .table-container {
        overflow-x: auto;
    }

    .boats-table {
        min-width: 600px;
    }
}
</style>