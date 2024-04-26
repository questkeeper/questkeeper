# deletePush

## 🧰 Usage

### GET /

- Returns a "Hello, World!" message.

**Response**

Sample `200` Response:

```text
Hello, World!
```

### POST, PUT, PATCH, DELETE /

- Returns a "Learn More" JSON response.

**Response**

Sample `200` Response:

```json
{
  "motto": "Build like a team of hundreds_",
  "learn": "https://appwrite.io/docs",
  "connect": "https://appwrite.io/discord",
  "getInspired": "https://builtwith.appwrite.io"
}
```

## ⚙️ Configuration

| Setting           | Value                    |
|-------------------|--------------------------|
| Runtime           | Deno (1.35)              |
| Entrypoint        | `src/main.ts`            |
| Build Commands    | `deno cache src/main.ts` |
| Permissions       | `any`                    |
| Timeout (Seconds) | 15                       |

## 🔒 Environment Variables

No environment variables required.
