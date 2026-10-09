# Un petit cache HTTP

*Notes de conception — version 2*

L'app interroge les trois mêmes points d'accès chaque minute. Un cache placé devant `URLSession` supprime la plupart de ces requêtes sans toucher à un seul appel.

## Règles

- Respecter `Cache-Control: max-age` ; ne jamais garder une réponse qui ne le porte pas
- Revalider une entrée périmée avec `ETag` et `If-None-Match`
- Garder au plus **200 entrées**, en évinçant la moins récemment utilisée

## La recherche

```swift
func data(for request: URLRequest) async throws -> Data {
    if let entry = store[request], entry.isFresh(at: .now) {
        return entry.data
    }
    let (data, response) = try await session.data(for: request)
    store.insert(data, for: request, response: response)
    return data
}
```

> Question ouverte : un `304 Not Modified` rajeunit-il l'entrée ? La RFC 9111 dit qu'il met à jour les en-têtes stockés ; nos premiers tests supposaient le contraire.

---

Suite : mesurer le taux de succès sur une journée de trafic réel.
