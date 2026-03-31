<h2>Accueil</h2>
<p>Bienvenue dans le prototype YRR.</p>

<div class="cards">
	<a class="card" href="/bateaux">Gérer les bateaux</a>
	<a class="card" href="/courses">Gérer les courses</a>
	<a class="card" href="/series">Gérer les séries</a>
	<a class="card" href="/inscriptions">Voir les inscriptions</a>
</div>

<style>
	h2 {
		margin-top: 0;
	}

	.cards {
		display: grid;
		grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
		gap: 16px;
		margin-top: 20px;
	}

	.card {
		background: white;
		padding: 20px;
		border-radius: 8px;
		text-decoration: none;
		color: black;
		box-shadow: 0 0 10px rgba(0,0,0,0.1);
	}
</style>