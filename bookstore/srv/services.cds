using {sap.capire.bookstore as db} from '../db/schema';

/*
It’s considered best practice to define services with a single use-case in mind.
For example, the AdminService is meant for administrating Products, Authors and Categories,
while the BooksService is meant for exposing a catalog of books and authors,
hiding administrative data such as creation and modification times from the end user.

*/

// BookService tarafından Books ve Authors, modificasyona'a kapatıyoruz, @readonly bu işe yarıyor.
// createdBy, createdAt, modifiedBy, modifiedAt bu alanlar dışında modifikasyon
// mappingte category'i genre olarak al.

// Define Books Service
service BooksService {
    @readonly
    entity Books   as projection on db.Books {
        * , category as genre
    } excluding {
        category,
        createdBy,
        createdAt,
        modifiedBy,
        modifiedAt
    };

    @readonly
    entity Authors as projection on db.Authors;
}

//The OrdersService allows to view, create, and delete orders.
//The entity OrderItems isn’t explicitly listed in the OrdersService.
//However, it will be automatically added to the service (auto-exposed),
//as the Orders entity defines a composition of OrderItems.
// Define Orders Service

service OrdersService {
    entity Orders as projection on db.Orders;
// OrderItems are auto exposed
}


//The AdminService is reused from the products service.
//But we’ve added the Authors entity to it.
//It can be used to create, update, and delete products and authors.
// Reuse Admin Service

using {AdminService} from '@sap/capire-products';

extend service AdminService with {
    entity Authors as projection on db.Authors;
}
