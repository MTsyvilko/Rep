@isTest
private class ProductDetailDescriptionControllerTest {        
    @isTest static void constructor() {
        ProductDetailDescriptionController controller = new ProductDetailDescriptionController();
        System.assert(controller.buyer != null);
        System.assert(controller.order != null);         
    }
    
    @isTest static void testGetProduct() {
        Product_Table__c product = createProductForController();
        ProductDetailDescriptionController controller = new ProductDetailDescriptionController();
        
        Product_Table__c result = controller.getProduct();
        System.assertEquals(product.Id, result.Id);
        System.assertEquals(product.Name, result.Name);
        System.assertEquals(product.Units_Available__c, result.Units_Available__c);
        System.assertEquals(product.Unit_Price__c, result.Unit_Price__c);
            
    }
    
    @isTest static void testCalculateTotalAmount() {
        Product_Table__c product = createProductForController();
        ProductDetailDescriptionController controller = new ProductDetailDescriptionController();	
        controller.order.Units__c = 10;      
        controller.calculateTotalAmount();
        System.assertEquals(10 * product.Unit_Price__c, controller.order.Order_Amount__c);
    }  
     
     @isTest static void test1Buy() {
         Product_Table__c product = createProductForController();
         ProductDetailDescriptionController controller = new  ProductDetailDescriptionController(); 
         controller.buyer.FirstName = 'TestFirstName';
         controller.buyer.LastName = 'TestLastName';
         controller.buyer.Email = 'GERr3rdfw342e4324@gmail.com';
         controller.order.Units__c = 30;                
         controller.buy();             
         Integer contactAfterBuy = [SELECT COUNT() 
                                    FROM Contact 
                                    WHERE Email = 'GERr3rdfw342e4324@gmail.com' AND 
                                          LastName = 'TestLastName' AND
                                    	  FirstName = 'TestFirstName'
                                   ];
         System.assertEquals(0, contactAfterBuy);  
        
         
     }
     @isTest static void tes2tBuy() {
         Product_Table__c product = createProductForController();
         ProductDetailDescriptionController controller = new  ProductDetailDescriptionController(); 
         controller.buyer.FirstName = 'TestFirstName';
         controller.buyer.LastName = 'TestLastName';
         controller.buyer.Email = 'GERr3rdfw342e4324@gmail.com';
         controller.order.Units__c = 5;                
         controller.buy();             
         Integer contactAfterBuy = [SELECT COUNT() 
                                    FROM Contact 
                                    WHERE Email = 'GERr3rdfw342e4324@gmail.com' AND 
                                          LastName = 'TestLastName' AND
                                    	  FirstName = 'TestFirstName'
                                   ];
         System.assertEquals(1, contactAfterBuy);  
        
         
     }
    
    static Product_Table__c createProductForController() {
        Product_Table__c product = new Product_Table__c();
        product.Name = 'TestName';
        product.Units_Available__c = 10;
        product.Unit_Price__c = 50;
        insert product;
        	
        PageReference pageRef = Page.DetailDescription; 
  		pageRef.getParameters().put('id', product.Id);
  		Test.setCurrentPage(pageRef);   
        
        return product;
    }
}