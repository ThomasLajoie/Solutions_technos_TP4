<script>
  let email = '';
  let password = '';

  function handleLogin() {
    console.log('Connexion:', { email, password });

 
  }
</script>

<h1>Connexion</h1>

<form on:submit|preventDefault={handleLogin}>
  <input
    type="email"
    placeholder="Email"
    bind:value={email}
    required
  />

  <input
    type="password"
    placeholder="Mot de passe"
    bind:value={password}
    required
  />

  <button type="submit">Se connecter</button>
</form>

<a href="/register">Créer un compte</a>

<style>
  form {
    display: flex;
    flex-direction: column;
    gap: 10px;
    max-width: 300px;
  }
</style>