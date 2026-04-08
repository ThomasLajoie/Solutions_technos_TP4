<script>
   let bateaux = [
	{
		id: 1,
		nom: "Le Gargantuesque",
		noVoile: 123,
		classe: "Cool",
		NomBarreur: "Dédé Fortin"
	},
	{
		id: 2,
		nom: "Le Bateau",
		noVoile: 456,
		classe: "Bato",
		NomBarreur: "Phil Collins"
	},
	{
		id: 3,
		nom: "L'Écume",
		noVoile: 789,
		classe: "Laser",
		NomBarreur: "Jean Tremblay"
	},
	{
		id: 4,
		nom: "Vent du Nord",
		noVoile: 321,
		classe: "420",
		NomBarreur: "Marie Gagnon"
	},
	{
		id: 5,
		nom: "Le Marlin Bleu",
		noVoile: 654,
		classe: "Open",
		NomBarreur: "Luc Bouchard"
	},
	{
		id: 6,
		nom: "Tempête Douce",
		noVoile: 987,
		classe: "Laser",
		NomBarreur: "Sophie Roy"
	},
	{
		id: 7,
		nom: "Le Flibustier",
		noVoile: 147,
		classe: "Cool",
		NomBarreur: "André Lavoie"
	},
	{
		id: 8,
		nom: "Aurore Marine",
		noVoile: 258,
		classe: "420",
		NomBarreur: "Julie Caron"
	},
	{
		id: 9,
		nom: "Éclair des Mers",
		noVoile: 369,
		classe: "Bato",
		NomBarreur: "Marc Bélanger"
	},
	{
		id: 10,
		nom: "Le Corsaire",
		noVoile: 159,
		classe: "Open",
		NomBarreur: "Nicolas Pelletier"
	},
	{
		id: 11,
		nom: "Brise Salée",
		noVoile: 753,
		classe: "Laser",
		NomBarreur: "Camille Morin"
	},
	{
		id: 12,
		nom: "Le Vif Argent",
		noVoile: 852,
		classe: "420",
		NomBarreur: "Olivier Côté"
	},
	{
		id: 13,
		nom: "Grand Large",
		noVoile: 951,
		classe: "Cool",
		NomBarreur: "Patrick Simard"
	},
	{
		id: 14,
		nom: "Le Goéland",
		noVoile: 741,
		classe: "Bato",
		NomBarreur: "Isabelle Fournier"
	},
	{
		id: 15,
		nom: "Onde Vive",
		noVoile: 963,
		classe: "Laser",
		NomBarreur: "Éric Dufresne"
	},
	{
		id: 16,
		nom: "Le Capitaine",
		noVoile: 357,
		classe: "Open",
		NomBarreur: "Hugo Paquette"
	},
	{
		id: 17,
		nom: "Perle Marine",
		noVoile: 8524,
		classe: "420",
		NomBarreur: "Valérie Nadeau"
	},
	{
		id: 18,
		nom: "Lame d'Eau",
		noVoile: 4567,
		classe: "Cool",
		NomBarreur: "Antoine Gervais"
	},
	{
		id: 19,
		nom: "Le Dauphin",
		noVoile: 2145,
		classe: "Bato",
		NomBarreur: "Karine Lévesque"
	},
	{
		id: 20,
		nom: "Horizon Bleu",
		noVoile: 6789,
		classe: "Open",
		NomBarreur: "Mathieu Cloutier"
	}
];

let nomBateau = '';
	let numeroVoile = '';
	let classeBateau = '';
	let nomBarreur = '';

function ajouterBateau(){

    bateaux.push({
            id: bateaux.length + 1,
            nom: nomBateau,
            noVoile: numeroVoile,
            classe: classeBateau,
            NomBarreur: nomBarreur
    });
    bateaux = bateaux;

    nomBateau = '';
    numeroVoile = '';
    classeBateau = '';
    nomBarreur = '';
}
</script>

<h2>Ajouter un bateau</h2>

<form action="http://localhost:4000/api/bateau" method="POST" on:submit|preventDefault={ajouterBateau}>
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