public class ProductListController 
{    
    public List<Product_Table__c> getProducts() {
        return [SELECT Name, Image_Url__c, Title__c, Description__c, Unit_Price__c FROM Product_Table__c limit 50];       
    }
    

    
}