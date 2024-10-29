public class PokemonService {
    @future(callout=true)
    public static void getPokemonData(String pokemonName) {
        try {
            
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            
            request.setEndpoint('https://pokeapi.co/api/v2/pokemon/' + pokemonName);
            request.setMethod('GET');
            
            HttpResponse response = http.send(request);
            
            
            if (response.getStatusCode() == 200) {
                System.debug('Response: ' + response.getBody());
                
                Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                System.debug('Nome del Pokémon: ' + result.get('name'));
                System.debug('Peso del Pokémon: ' + result.get('weight'));
                System.debug('Tipo del Pokémon: ' + result.get('types'));
                
            } else {
                System.debug('Errore nella risposta: ' + response.getStatus());
            }
        } catch (Exception e) {
            System.debug('Eccezione: ' + e.getMessage());
        }
    }
}
