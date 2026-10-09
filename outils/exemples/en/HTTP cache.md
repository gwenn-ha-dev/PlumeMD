# A small HTTP cache

*Design notes — draft 2*

The app asks the same three endpoints every minute. A cache in front of `URLSession` removes most of those requests without changing a single call site.

## Rules

- Honour `Cache-Control: max-age`; never cache a response without it
- Revalidate a stale entry with `ETag` and `If-None-Match`
- Keep at most **200 entries**, evicting the least recently used

## The lookup

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

> Open question: does a `304 Not Modified` refresh the entry's age? RFC 9111 says it updates the stored headers; our first tests assumed it did not.

---

Next: measure the hit rate over a day of real traffic.
