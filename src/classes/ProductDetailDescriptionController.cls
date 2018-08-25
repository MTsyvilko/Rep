public class ProductDetailDescriptionController 
{  
    public Contact buyer {get; set;}
    public Order_Table__c order {get; set;}
    
   
    public ProductDetailDescriptionController() {
        buyer = new Contact();        
        order = new Order_Table__c();        
    }
    
    public void calculateTotalAmount() {
        order.Order_Amount__c = order.Units__c * getProduct().Unit_Price__c;
    }
    
    public void buy(){
        Savepoint sp = Database.setSavepoint();
        
        List<Contact> exsistentContacts = [SELECT FirstName, LastName, Email FROM Contact WHERE Email = :buyer.Email];
        if (exsistentContacts.size() > 0) {
            Contact exsistentContact = exsistentContacts[0];
            exsistentContact.FirstName = buyer.FirstName;
            exsistentContact.LastName = buyer.LastName;
            update exsistentContact;
            buyer = exsistentContact;
        }
        else {
           	insert buyer;       
        }
        
        Product_Table__c product = getProduct();
        
        order.Product_Table__c = product.Id;
        calculateTotalAmount();
        order.Contact__c = buyer.Id;
        insert order;
        
        product.Units_Available__c = product.Units_Available__c - order.Units__c;
        if (product.Units_Available__c >= 0) {
            update product;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm, 
            	'Your order has been successfully confirmed! Thank you!'));
        }
        else {
            Database.rollback(sp);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 
            	'Error in Unit Count field. You should enter another value!'));     
        }               
    }    
    
    public Product_Table__c getProduct() {                   
        List<Product_Table__c> productList = 
            [SELECT Name, Image_Url__c, Title__c, Description__c, Units_Available__c, Unit_Price__c
            FROM Product_Table__c 
            WHERE id = :ApexPages.currentPage().getParameters().get('id')]; 
        return productList[0];
    }     
}