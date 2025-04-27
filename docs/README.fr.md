# Context7 MCP - Documentation à jour pour vos prompts

[![Site Web](https://img.shields.io/badge/Website-context7.com-blue)](https://context7.com) [![badge smithery](https://smithery.ai/badge/@upstash/context7-mcp)](https://smithery.ai/server/@upstash/context7-mcp)[<img alt="Installer dans VS Code (npx)" src="https://img.shields.io/badge/VS_Code-VS_Code?style=flat-square&label=Installer%20Context7%20MCP&color=0098FF">](https://insiders.vscode.dev/redirect?url=vscode%3Amcp%2Finstall%3F%257B%2522name%2522%253A%2522context7%2522%252C%2522config%2522%253A%257B%2522command%2522%253A%2522npx%2522%252C%2522args%2522%253A%255B%2522-y%2522%252C%2522%2540upstash%252Fcontext7-mcp%2540latest%2522%255D%257D%257D)

## ❌ Sans Context7

Les LLMs s’appuient sur des informations obsolètes ou génériques concernant les bibliothèques que vous utilisez. Vous obtenez :

- ❌ Des exemples de code obsolètes, basés sur des données d’entraînement vieilles d’un an
- ❌ Des APIs inventées qui n’existent même pas
- ❌ Des réponses génériques pour d’anciennes versions de packages

## ✅ Avec Context7

Context7 MCP récupère la documentation et les exemples de code à jour, spécifiques à la version, directement à la source — et les place dans votre prompt.

Ajoutez `use context7` à votre prompt dans Cursor :

```txt
Crée un projet Next.js basique avec app router. use context7
```

```txt
Crée un script pour supprimer les lignes où la ville est "" avec des identifiants PostgreSQL. use context7
```

Context7 apporte des exemples de code et de la documentation à jour directement dans le contexte de votre LLM.

- 1️⃣ Rédigez votre prompt naturellement
- 2️⃣ Dites au LLM `use context7`
- 3️⃣ Obtenez des réponses de code qui fonctionnent

Plus besoin de changer d’onglet, plus d’APIs inventées, plus de code obsolète.

## 🛠️ Démarrage

### Prérequis

- Node.js >= v18.0.0
- Cursor, Windsurf, Claude Desktop ou un autre client MCP

### Installation via Smithery

Pour installer Context7 MCP Server pour Claude Desktop automatiquement via [Smithery](https://smithery.ai/server/@upstash/context7-mcp) :

```bash
npx -y @smithery/cli install @upstash/context7-mcp --client claude
```

### Installation dans Cursor

Allez dans : `Settings` -> `Cursor Settings` -> `MCP` -> `Add new global MCP server`

La méthode recommandée est de coller la configuration suivante dans votre fichier `~/.cursor/mcp.json`. Voir la [documentation Cursor MCP](https://docs.cursor.com/context/model-context-protocol) pour plus d’informations.

```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"]
    }
  }
}
```

<details>
<summary>Alternative : Utiliser Bun</summary>

```json
{
  "mcpServers": {
    "context7": {
      "command": "bunx",
      "args": ["-y", "@upstash/context7-mcp@latest"]
    }
  }
}
```

</details>

<details>
<summary>Alternative : Utiliser Deno</summary>

```json
{
  "mcpServers": {
    "context7": {
      "command": "deno",
      "args": ["run", "--allow-net", "npm:@upstash/context7-mcp"]
    }
  }
}
```

</details>

### Installation dans Windsurf

Ajoutez ceci à votre fichier de configuration MCP Windsurf. Voir la [documentation Windsurf MCP](https://docs.windsurf.com/windsurf/mcp) pour plus d’informations.

```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"]
    }
  }
}
```

### Installation dans VS Code

[<img alt="Installation dans VS Code (npx)" src="https://img.shields.io/badge/VS_Code-VS_Code?style=flat-square&label=Installer%20Context7%20MCP&color=0098FF">](https://insiders.vscode.dev/redirect?url=vscode%3Amcp%2Finstall%3F%257B%2522name%2522%253A%2522context7%2522%252C%2522config%2522%253A%257B%2522command%2522%253A%2522npx%2522%252C%2522args%2522%253A%255B%2522-y%2522%252C%2522%2540upstash%252Fcontext7-mcp%2540latest%2522%255D%257D%257D)
[<img alt="Installation dans VS Code Insiders (npx)" src="https://img.shields.io/badge/VS_Code_Insiders-VS_Code_Insiders?style=flat-square&label=Installer%20Context7%20MCP&color=24bfa5">](https://insiders.vscode.dev/redirect?url=vscode-insiders%3Amcp%2Finstall%3F%257B%2522name%2522%253A%2522context7%2522%252C%2522config%2522%253A%257B%2522command%2522%253A%2522npx%2522%252C%2522args%2522%253A%255B%2522-y%2522%252C%2522%2540upstash%252Fcontext7-mcp%2540latest%2522%255D%257D%257D)

Ajoutez ceci à votre fichier de configuration MCP VS Code. Voir la [documentation VS Code MCP](https://code.visualstudio.com/docs/copilot/chat/mcp-servers) pour plus d’informations.

```json
{
  "servers": {
    "Context7": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"]
    }
  }
}
```

### Installation dans Zed

Peut être installé via [Zed Extensions](https://zed.dev/extensions?query=Context7) ou en ajoutant ceci à votre `settings.json` Zed. Voir la [documentation Zed Context Server](https://zed.dev/docs/assistant/context-servers).

```json
{
  "context_servers": {
    "Context7": {
      "command": {
        "path": "npx",
        "args": ["-y", "@upstash/context7-mcp@latest"]
      },
      "settings": {}
    }
  }
}
```

### Installation dans Claude Code

Exécutez cette commande. Voir la [documentation Claude Code MCP](https://docs.anthropic.com/en/docs/agents-and-tools/claude-code/tutorials#set-up-model-context-protocol-mcp).

```sh
claude mcp add context7 -- npx -y @upstash/context7-mcp@latest
```

### Installation dans Claude Desktop

Ajoutez ceci à votre fichier `claude_desktop_config.json`. Voir la [documentation Claude Desktop MCP](https://modelcontextprotocol.io/quickstart/user).

```json
{
  "mcpServers": {
    "Context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"]
    }
  }
}
```

### Utilisation avec Docker

Si vous préférez exécuter le serveur MCP dans un conteneur Docker :

1.  **Construisez l’image Docker :**

    Créez un `Dockerfile` à la racine du projet (ou ailleurs) :

    <details>
    <summary>Voir le contenu du Dockerfile</summary>

    ```Dockerfile
    FROM node:18-alpine

    WORKDIR /app

    # Installer la dernière version en global
    RUN npm install -g @upstash/context7-mcp@latest

    # Exposer le port par défaut si besoin (optionnel)
    # EXPOSE 3000

    # Commande par défaut
    CMD ["context7-mcp"]
    ```

    </details>

    Puis, construisez l’image :

    ```bash
    docker build -t context7-mcp .
    ```

2.  **Configurez votre client MCP :**

    Mettez à jour la configuration de votre client MCP pour utiliser la commande Docker.

    *Exemple pour un fichier cline_mcp_settings.json :*

    ```json
    {
      "mcpServers": {
        "Сontext7": {
        "autoApprove": [],
        "disabled": false,
        "timeout": 60,
          "command": "docker",
          "args": ["run", "-i", "--rm", "context7-mcp"],
          "transportType": "stdio"
        }
      }
    }
    ```
    *Note : Ceci est un exemple. Adaptez la structure selon votre client MCP (voir plus haut dans ce README). Assurez-vous que le nom de l’image dans `args` correspond au tag utilisé lors du build.*

### Outils disponibles

- `resolve-library-id` : Résout un nom de bibliothèque général en un ID compatible Context7.
  - `libraryName` (obligatoire)
- `get-library-docs` : Récupère la documentation d’une bibliothèque via un ID Context7.
  - `context7CompatibleLibraryID` (obligatoire)
  - `topic` (optionnel) : Focaliser la doc sur un sujet précis (ex : "routing", "hooks")
  - `tokens` (optionnel, par défaut 5000) : Nombre max de tokens à retourner. Les valeurs < 5000 sont automatiquement augmentées à 5000.

## Développement

Clonez le projet et installez les dépendances :

```bash
bun i
```

Build :

```bash
bun run build
```

### Exemple de configuration locale

```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["tsx", "/path/to/folder/context7-mcp/src/index.ts"]
    }
  }
}
```

### Tester avec MCP Inspector

```bash
npx -y @modelcontextprotocol/inspector npx @upstash/context7-mcp@latest
```

## Dépannage

### ERR_MODULE_NOT_FOUND

Si vous voyez cette erreur, essayez d’utiliser `bunx` à la place de `npx`.

```json
{
  "mcpServers": {
    "context7": {
      "command": "bunx",
      "args": ["-y", "@upstash/context7-mcp@latest"]
    }
  }
}
```

Cela résout souvent les problèmes de résolution de modules, surtout si `npx` n’installe ou ne résout pas correctement les packages.

### Erreurs client MCP

1. Essayez de retirer `@latest` du nom du package.
2. Essayez d’utiliser `bunx` comme alternative.
3. Essayez d’utiliser `deno` comme alternative.

## Context7 dans les médias

- [Better Stack: "Free Tool Makes Cursor 10x Smarter"](https://youtu.be/52FC3qObp9E)
- [Cole Medin: "This is Hands Down the BEST MCP Server for AI Coding Assistants"](https://www.youtube.com/watch?v=G7gK8H6u7Rs)
- [Income stream surfers: "Context7 + SequentialThinking MCPs: Is This AGI?"](https://www.youtube.com/watch?v=-ggvzyLpK6o)
- [Julian Goldie SEO: "Context7: New MCP AI Agent Update"](https://www.youtube.com/watch?v=CTZm6fBYisc)
- [JeredBlu: "Context 7 MCP: Get Documentation Instantly + VS Code Setup"](https://www.youtube.com/watch?v=-ls0D-rtET4)
- [Income stream surfers: "Context7: The New MCP Server That Will CHANGE AI Coding"](https://www.youtube.com/watch?v=PS-2Azb-C3M)

## Historique des stars

[![Graphique d'historique des stars](https://api.star-history.com/svg?repos=upstash/context7&type=Date)](https://www.star-history.com/#upstash/context7&Date)

## Licence

MIT
