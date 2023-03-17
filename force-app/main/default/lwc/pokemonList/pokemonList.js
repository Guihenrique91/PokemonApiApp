/*
*Nome: Guilherme Henrique Correia da Silva
*Email: guilhermehenrquecds@gmail.com
*/
import { LightningElement,api } from 'lwc';
import getPokemons from '@salesforce/apex/PokemonClass.getPokemons';
import getPokemonsTipoGeracao from '@salesforce/apex/PokemonClass.getPokemonsTipoGeracao';
import { NavigationMixin } from 'lightning/navigation';
import batch from '@salesforce/apex/PokemonClass.batch';


export default class PokemonCardList extends NavigationMixin(LightningElement) {
    
    searchWord='';
    pokemons;
    error;
    searchWords='';
    isSearchAvaliable =false;
    searchGeracao=0;
    searchTipo='';
    contPokemon=0;
    

   connectedCallback(){
        this.loadPokemons(this.searchWords);
    }

    handlerSearch(event){        
        this.searchWords = event.target.value;
        this.loadPokemons(this.searchWords);
    }
    loadPokemons (searchWords){
        getPokemons({searchWord:searchWords})
        .then(result =>{
            this.pokemons = result;
            this.contPokemon=this.pokemons.length;
            console.log(" this pokemons: " +JSON.stringify(this.pokemons));
            if(this.pokemons.length > 0){
                this.isSearchAvaliable = false;
            }else{
                this.isSearchAvaliable = true;
            }
        })
        .catch(error =>{
            this.isSearchAvaliable = false;
            this.error = error;
        })
    }

    get options() {
        return [
            { label: 'All', value: '' },
            { label: 'Normal', value: 'normal' },
            { label: 'Fighting', value: 'fighting' },
            { label: 'Flying', value: 'flying' },
            { label: 'Poison', value: 'poison' },
            { label: 'Ground', value: 'ground' },
            { label: 'Rock', value: 'rock' },
            { label: 'Bug', value: 'bug' },
            { label: 'Ghost', value: 'ghost' },
            { label: 'Steel', value: 'steel' },
            { label: 'Fire', value: 'fire' },
            { label: 'Water', value: 'water' },
            { label: 'Grass', value: 'grass' },
            { label: 'Electric', value: 'electric' },
            { label: 'Psychic', value: 'psychic' },
            { label: 'Ice', value: 'ice' },
            { label: 'Dragon', value: 'dragon' },
            { label: 'Dark', value: 'dark' },
            { label: 'Fairy', value: 'fairy' },
        ];
    }

    handleTipo(event) {     
        this.searchTipo = event.target.value;
        //this.loadPokemonsTipo(this.searchTipo);
        this.loadPokemonsGeracao(this.searchTipo,this.searchGeracao);       
    }
    loadPokemonsTipo (searchTipo, searchGeracao){
        getPokemonsTipoGeracao({ searchTipo:searchTipo, searchGeracao:searchGeracao })
        .then(result =>{
            this.pokemons = result;
            this.contPokemon=this.pokemons.length;
            console.log(" this pokemons: " +JSON.stringify(this.pokemons));
            if(this.pokemons.length > 0){
                this.isSearchAvaliable = false;
            }else{
                this.isSearchAvaliable = true;
            }
        })
        .catch(error =>{
            this.isSearchAvaliable = false;
            this.error = error;
        })
    }

    get optionsGeracao() {
        return [
            { label: 'All', value:0 },
            { label: '1° Geração', value:1 },
            { label: '2° Geração', value:2 },
            { label: '3° Geração', value:3 },
            { label: '4° Geração', value:4 },
            { label: '5° Geração', value:5 },
      
        ];
    }
    handleGeracao(event) {
        this.searchGeracao = event.target.value;
        this.loadPokemonsGeracao(this.searchGeracao, this.searchTipo);
        //this.loadPokemonsTipo(parseInt(this.searchGeracao));   
    }
    loadPokemonsGeracao (searchGeracao, searchTipo){
        getPokemonsTipoGeracao({searchGeracao:searchGeracao,searchTipo:searchTipo})
        .then(result =>{
            this.pokemons = result;
            this.contPokemon=this.pokemons.length;
            console.log(" this pokemons: " +JSON.stringify(this.pokemons));
           if(this.pokemons.length > 0){
                this.isSearchAvaliable = false;
            }else{
                this.isSearchAvaliable = true;
            }
        })
        .catch(error =>{
            this.isSearchAvaliable = false;
            this.error = error;
        })
    }

    handlePokeView(event) {
        const idPoke = event.target.value;
        this[NavigationMixin.Navigate](    
        {
        type: "standard__app",
        attributes: {
            appTarget: "standard__LightningSales",
            pageRef: {
                type: "standard__recordPage",
                attributes: {
                    recordId: idPoke,
                    objectApiName: "Pokemon__c",
                    actionName: "view"
                }
            }
        }
        }
        );
	}
    
    handleClickBatch(){
        batch().then(
           
        ).catch(err => {
            console.log('err ', err);
        });

        alert(" ATENÇÃO: Apos clicar para carregar os Pokemons, favor aguardar caso nao atulizar sozinho, por favor atualize a pagina");
        setTimeout(function(){
            window.location.reload();
         }, 25000);
     
    }

}