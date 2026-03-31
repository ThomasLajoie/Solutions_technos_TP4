<script>
	let { children } = $props();
</script>

<header class="header">
	<h1>YRR Prototype</h1>

	<nav>
		<a href="/inscription">S'inscrire</a>
		<a href="/connexion">Se connecter</a>
		<a href="/">Accueil</a>
		<a href="/bateaux">Bateaux</a>
		<a href="/courses">Courses</a>
		<a href="/series">Séries</a>
		<a href="/inscriptions">Inscriptions</a>
	</nav>
</header>

<main class="content">
	{@render children()}
</main>

<style>
	:global(body) {
		margin: 0;
		font-family: Arial, sans-serif;
		background: #f4f6f8;
	}

	.header {
		background: #444;
		color: white;
		padding: 16px 24px;
		display: flex;
		justify-content: space-between;
		align-items: center;
		flex-wrap: wrap;
	}

	.header h1 {
		margin: 0;
		font-size: 1.4rem;
	}

	nav {
		display: flex;
		gap: 12px;
		flex-wrap: wrap;
	}

	nav a {
		color: white;
		text-decoration: none;
		background: #666;
		padding: 8px 12px;
		border-radius: 6px;
	}

	nav a:hover {
		background: #888;
	}

	.content {
		padding: 24px;
	}
</style>