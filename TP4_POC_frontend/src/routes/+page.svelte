<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Formulaire Bateau</title>
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
    </style>
</head>
<body>

<form action="http://localhost:4000/api/bateau" method="POST">
    <h2>Informations du bateau</h2>

    <label for="nomBateau">Nom du bateau</label>
    <input type="text" id="nomBateau" name="nom_bateau" required>

    <label for="numeroVoile">Numéro de voile</label>
    <input type="text" id="numeroVoile" name="numero_voile" required>

    <label for="classeBateau">Classe du bateau</label>
    <input type="text" id="classeBateau" name="classe_bateau" required>

    <label for="nomBarreur">Nom du barreur</label>
    <input type="text" id="nomBarreur" name="nom_barreur" required>

    <button type="submit">Envoyer</button>
</form>

</body>
</html>
