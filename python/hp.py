from mobi import Mobi

book = Mobi("/Users/jakeireland/Desktop/Rowling, J K - Harry Potter 01 - The Philosophers Stone (v5.0)");
book.parse();
for record in book:
    print(record)
