namespace sap.capire.bookstore;

using {
    Currency,
    cuid,
    managed
} from '@sap/cds/common';
using {sap.capire.products.Products} from '@sap/capire-products';

entity Books as projection on Products;

extend Products with {
    // Note: we map Books to Products to allow reusing AdminService as is
    author : Association to Authors;
}

entity Authors : cuid {
    firstname : String(111);
    lastname  : String(111);
    books     : Association to many Books
                    on books.author = $self;
}

@Capabilities.Updatable : false // Entity update edilemez, sadece yaratılabilir yada silinebilir.
entity Orders : cuid, managed {
    items    : Composition of many OrderItems
                   on items.parent = $self;
    total    : Decimal(9, 2)@readonly; // readonly anlamı, frontend tarafından gelmeyecek, custom code'da hesaplacak.
    currency : Currency; // sap node library'lerinden gelecek, value help'te sıkça kullanılıyor.
}

@Capabilities.Updatable : false
entity OrderItems : cuid {
    parent    : Association to Orders not null; // order -items parent-child ilişkisi.
    book_ID   : UUID; // Herhangi bir ilişki yok, custom code'da kitabın uuid'si maplenecek.
    amount    : Integer;
    netAmount : Decimal(9, 2)@readonly;
}
