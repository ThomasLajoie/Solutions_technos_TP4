<script>
    import { goto } from '$app/navigation';
	import { isConnected } from '$lib/stores/auth';
	let { children } = $props();

	function logout() {
		isConnected.set(false); 
		goto('/');
	}
</script>

<header class="header">
	<div class="logo-container">
		<a href="/" class="logo-link">	
			<img src="/logo.png" alt="logo" height="80px"/>
			<h1>YRR Prototype</h1>
		</a>
	</div>

	{#if !$isConnected}
	<nav>
		<a href="/inscription">S'inscrire</a>
		<a href="/connexion">Se connecter</a>
	</nav>
{:else}
	<nav>
		<a href="/bateaux">Bateaux</a>
		<a href="/courses">Courses</a>
		<a href="/inscriptions">Inscriptions</a>
		<!-- svelte-ignore event_directive_deprecated -->
		<button on:click={logout}>Déconnexion</button>
	</nav>
{/if}
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

	.logo-container {
		display: flex;
		align-items: center;
	}

	.logo-link {
		display: flex;
		align-items: center;
		gap: 10px;
		text-decoration: none;
		color: white;
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

	nav button {
		all: unset;
		color: white;
		text-decoration: none;
		background: #666;
		padding: 8px 12px;
		border-radius: 6px;
	}

	nav a:hover {
		background: #888;
	}

	nav button:hover {
		background: #888;
	}


	.content {
		padding: 24px;
	}
</style>