/*
*Nome: Guilherme Henrique Correia da Silva
*Email: guilhermehenrquecds@gmail.com
*/
global class Batch implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
    public static Pokemon__c Pokemons = new Pokemon__c();

 public static Pokemon__c Pk = new Pokemon__c();
 public static List<Pokemon__c> Pkaux = new List<Pokemon__c>();
 
 public Integer pokemonId = 1;
 global Database.QueryLocator start(Database.BatchableContext BC) {
     System.debug('pokemon Id' + pokemonId);
     return Database.getQueryLocator([SELECT ID,FirstName, LastName, Email, Name FROM Contact LIMIT 9]);
 }
 global void execute(Database.BatchableContext BC, List<Contact> records) {         
     
     for (integer i = 1; i <= records.size(); i++ ) {
         for(Integer contPok = 1; contPok <= 100 && pokemonId <= 898; contPok++) {
     try{        
         RestModelPok wrapper = new RestModelPok();
         Http http = new Http();
         HttpRequest req = new HttpRequest();
         req.setEndpoint('https://pokeapi.co/api/v2/pokemon/'+pokemonId+'/');
         req.setMethod('GET');
         HttpResponse res = http.send(req);
         
         if(res.getStatusCode() == 200){
             wrapper = (RestModelPok) JSON.deserialize(res.getBody(), RestModelPok.Class);
             System.debug(wrapper);
             String ListaName = '';
             String TipoName;
             for(TypesModel t : wrapper.types){
                  ListaName = ListaName +' ; '+ t.type.name ;
                  TipoName = ListaName;                  	
                 }  
                 Integer generation; 
                 If(wrapper.id<=151){
                     generation=1;
                 }else if(wrapper.id>151 && wrapper.id<=251){
                        generation=2;
                 }else if(wrapper.id>251 && wrapper.id<=386){
                       generation=3;
                 }else if(wrapper.id>386 && wrapper.id<=493){
                       generation=4;
                 }else {
                        generation=5;
                 }
                 
                  Pkaux.add(new Pokemon__c(Name = wrapper.name.capitalize(), 
                  Height__c =String.valueOf(wrapper.height/10) + 'm' , 
                  Weight__c=String.valueof(wrapper.weight/10)+'Kg',
                  picture_url__c=wrapper.sprites.other.home.front_default,
                  Type__c = TipoName,
                  PokeIndex__c = wrapper.id,
                  Generation__c=generation
                  ));
                            
              
         }else {
             System.debug('Falha ao obter dados da API. Status code: ' + res.getStatusCode());  
         }          
     }
     catch(Exception e){
         System.debug('Exception! Mensagem: ' + e.getMessage() + ' Linha: ' + e.getLineNumber());
     } 	
             pokemonId++;
             
         }
   
          insert Pkaux;
     }
     System.debug('Lista ' + Pkaux);
             
 }

 global void finish(Database.BatchableContext BC){

 }
}