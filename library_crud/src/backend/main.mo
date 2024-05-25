
import Nat32 "mo:base/Nat32";
import Text "mo:base/Text";
import Trie "mo:base/Trie";
import Option "mo:base/Option";
import Types "Types";

actor {

  type Id = Nat32;
  type BookCart = {
      book: Types.Book;
  };

  private stable var next : Id = 0;
  private stable var cart : Trie.Trie<Id, BookCart> = Trie.empty();

  // Kitap ekleme işlevi
  public func addBook(title: Text, author: Text): async Id {
    let id = next;
    next += 1;
    let newBook: Types.Book = { id; title; author };
    let bookCart: BookCart = { book = newBook };
    cart := Trie.replace(
      cart,
      key(id),
      Nat32.equal,
      ?bookCart,
    ).0;
    return id;
  };

  // Kitapları listeleme işlevi
  public query func read(id : Id) : async ? BookCart {
    let result = Trie.find(cart, key(id), Nat32.equal);
    return result;

  };

  // Kitap güncelleme işlevi
  public func updateBook(id: Id, title: Text, author: Text): async Bool {
    let result = Trie.find(cart, key(id), Nat32.equal);
    let exists = Option.isSome(result);
    if (exists) {
      let updatedBook: Types.Book = { id; title; author };
      let bookCart: BookCart = { book = updatedBook };
      cart := Trie.replace(
        cart,
        key(id),
        Nat32.equal,
        ?bookCart
      ).0;
    };
    exists
  };

  // Kitap silme işlevi
  public func deleteBook(id: Id): async Bool {
    let result = Trie.find(cart, key(id), Nat32.equal);
    let exists = Option.isSome(result);
    if (exists) {
      cart := Trie.replace(
        cart,
        key(id),
        Nat32.equal,
        null
      ).0;
    };
    exists
  };


  private func key(x: Id): Trie.Key<Id> {
    return { hash = x; key = x };
  };
}

