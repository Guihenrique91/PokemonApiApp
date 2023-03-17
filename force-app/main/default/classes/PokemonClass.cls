/*
*Nome: Guilherme Henrique Correia da Silva
*Email: guilhermehenrquecds@gmail.com
*/
public with sharing class PokemonClass {
    @AuraEnabled(cacheable=true)
    public static List<Pokemon__c> getPokemons(String searchWord){
        if(searchWord != ''){
            String key =  '%' + searchWord + '%';
            List<Pokemon__c> pokemonSearchList = [SELECT Id, Name, Generation__c, PokeIndex__c, picture_url__c, Height__c, Weight__c, Type__c
            FROM Pokemon__c
            WHERE Name LIKE :key  ORDER BY PokeIndex__c ];
            return pokemonSearchList;
        }else {
         List<Pokemon__c> pokemonList = [SELECT Id, Name, Generation__c, PokeIndex__c, picture_url__c, Height__c, Weight__c, Type__c 
                                            FROM Pokemon__c 
                                            ORDER BY PokeIndex__c ];
            if (!pokemonList.isEmpty()){
                return  pokemonList;
            }
    
            return NULL;       
        }
    }
    @AuraEnabled()
    public static List<Pokemon__c> getPokemonsTipoGeracao( Integer searchGeracao, String searchTipo){
        
        if(searchTipo != '' && searchGeracao==0){
            List<Pokemon__c> pokemonSearchList = [SELECT Id, Name, Generation__c, PokeIndex__c, picture_url__c, Height__c, Weight__c, Type__c
            FROM Pokemon__c
            WHERE Type__c INCLUDES (:searchTipo) 
            ORDER BY PokeIndex__c ];
            return pokemonSearchList;
        }
        if(searchGeracao !=0 && searchTipo == ''){
            List<Pokemon__c> pokemonSearchList = [SELECT Id, Name, Generation__c, PokeIndex__c, picture_url__c, Height__c, Weight__c, Type__c
            FROM Pokemon__c
            WHERE  Generation__c=:searchGeracao ORDER BY PokeIndex__c ];
        }
         if(searchTipo != '' && searchGeracao != 0){
            String key =  '%' + searchTipo + '%';
            List<Pokemon__c> pokemonSearchList = [SELECT Id, Name, Generation__c, PokeIndex__c, picture_url__c, Height__c, Weight__c, Type__c
            FROM Pokemon__c
            WHERE (Type__c INCLUDES (:searchTipo) AND Generation__c=:searchGeracao )
            ORDER BY PokeIndex__c ];
            return pokemonSearchList;
        }else if(searchTipo != '' || searchGeracao != 0){
            List<Pokemon__c> pokemonSearchList = [SELECT Id, Name, Generation__c, PokeIndex__c, picture_url__c, Height__c, Weight__c, Type__c
            FROM Pokemon__c
            WHERE Type__c INCLUDES (:searchTipo) 
            OR  Generation__c=:searchGeracao ORDER BY PokeIndex__c ];
            return pokemonSearchList;
        }else if(searchGeracao == 0){
            List<Pokemon__c> pokemonListAll = [SELECT Id, Name, Generation__c, PokeIndex__c, picture_url__c, Height__c, Weight__c, Type__c 
            FROM Pokemon__c ORDER BY PokeIndex__c ];

            return pokemonListAll;
        }else{
         List<Pokemon__c> pokemonList = [SELECT Id, Name, Generation__c, PokeIndex__c, picture_url__c, Height__c, Weight__c, Type__c 
                                            FROM Pokemon__c ORDER BY PokeIndex__c ];
            if (!pokemonList.isEmpty()){
                return  pokemonList;
            }
    
            return NULL;       
        }
    }

    @AuraEnabled
    public static void batch(){
        Database.executeBatch(new Batch(), 1);
    }

}