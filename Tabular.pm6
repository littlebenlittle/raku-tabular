use v6;

unit module Tabular;

grammar Data {
    token TOP {
        <header-row>    \n
        <value-row>+ %% \n
    }
    token header-row { <.ws>+ %% <header> }
    token value-row  { <.ws>+ %% <value> }
    token value  { \S+ [\h \S+]* }
    token header { \S+ [\h \S+]* }
    token ws     { \h* }
} 

class Actions {
    method TOP ($/) {
        my @entries;
        my @headers = $<header-row>.made;
        my @rows    = $<value-row>.map: *.made;
        for @rows -> @values {
            my %entry = flat @headers Z @values;
            @entries.push: %entry;
        }
        make @entries;
    }
    method header-row ($/) {
        my   @headers = $<header>.map: *.Str;
        make @headers;
    }
    method value-row  ($/) {
        my   @values = $<value>.map: *.Str;
        make @values;
    }
}

grammar DataWithFooter is Data {
    token TOP  { 
        <header-row>    \n
        <value-row>+ %% \n
        <footer-row>    \n?
    }
    token value-row  { <!before <footer-start>> <.ws>+ %% <value> }
    token footer-row { <.footer-start> .*  }
    token footer-start { ... }
}

