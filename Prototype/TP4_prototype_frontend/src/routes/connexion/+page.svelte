<h2>Connexion</h2>

<form on:submit|preventDefault={handleLogin}>
    <h2>Se connecter</h2>

    <label for="email">Email</label>
    <input type="email" id="email" bind:value={email} required>

    <label for="password">Mot de passe</label>
    <input type="password" id="password" bind:value={password} required>

    <button type="submit">Se connecter</button>
</form>

<a href="/register">Créer un compte</a>

<script>
    let email = '';
    let password = '';

    function handleLogin() {
        console.log('Connexion:', { email, password });
    }
</script>

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

    a {
        display: block;
        text-align: center;
        margin-top: 10px;
    }
</style>