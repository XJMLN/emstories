(function(t){function a(a){for(var s,o,r=a[0],l=a[1],c=a[2],u=0,p=[];u<r.length;u++)o=r[u],Object.prototype.hasOwnProperty.call(i,o)&&i[o]&&p.push(i[o][0]),i[o]=0;for(s in l)Object.prototype.hasOwnProperty.call(l,s)&&(t[s]=l[s]);d&&d(a);while(p.length)p.shift()();return n.push.apply(n,c||[]),e()}function e(){for(var t,a=0;a<n.length;a++){for(var e=n[a],s=!0,r=1;r<e.length;r++){var l=e[r];0!==i[l]&&(s=!1)}s&&(n.splice(a--,1),t=o(o.s=e[0]))}return t}var s={},i={app:0},n=[];function o(a){if(s[a])return s[a].exports;var e=s[a]={i:a,l:!1,exports:{}};return t[a].call(e.exports,e,e.exports,o),e.l=!0,e.exports}o.m=t,o.c=s,o.d=function(t,a,e){o.o(t,a)||Object.defineProperty(t,a,{enumerable:!0,get:e})},o.r=function(t){"undefined"!==typeof Symbol&&Symbol.toStringTag&&Object.defineProperty(t,Symbol.toStringTag,{value:"Module"}),Object.defineProperty(t,"__esModule",{value:!0})},o.t=function(t,a){if(1&a&&(t=o(t)),8&a)return t;if(4&a&&"object"===typeof t&&t&&t.__esModule)return t;var e=Object.create(null);if(o.r(e),Object.defineProperty(e,"default",{enumerable:!0,value:t}),2&a&&"string"!=typeof t)for(var s in t)o.d(e,s,function(a){return t[a]}.bind(null,s));return e},o.n=function(t){var a=t&&t.__esModule?function(){return t["default"]}:function(){return t};return o.d(a,"a",a),a},o.o=function(t,a){return Object.prototype.hasOwnProperty.call(t,a)},o.p="";var r=window["webpackJsonp"]=window["webpackJsonp"]||[],l=r.push.bind(r);r.push=a,r=r.slice();for(var c=0;c<r.length;c++)a(r[c]);var d=l;n.push([0,"chunk-vendors"]),e()})({0:function(t,a,e){t.exports=e("56d7")},4218:function(t,a,e){t.exports=e.p+"img/department-5.png"},"56d7":function(t,a,e){"use strict";e.r(a);e("cadf"),e("551c"),e("f751"),e("097d");var s=e("2b0e"),i=e("3f08"),n=e("ecee"),o=e("c074"),r=e("ad3d"),l=function(){var t=this,a=t.$createElement,e=t._self._c||a;return t.render?e("main",{key:t.render,staticClass:"page-wrapper with-sidebar with-navbar",attrs:{id:"app"}},[e("mdt-header",{attrs:{darkMode:t.darkMode,playerData:t.playerData,closeApp:t.closeApp}}),e("div",{staticClass:"sidebar-overlay"}),e("mdt-subheader",{attrs:{playerData:t.playerData,switchPage:t.switchPage,siteNumber:t.site}}),e("div",{staticClass:"content-wrapper"},[1==t.site?e("div",{key:t.site,staticClass:"w-full h-full d-flex"},[e("mdt-person",{attrs:{citationConfig:t.citationsData,switchPage:t.switchPage,personSearchError:t.personSearchError,loadedPersonData:t.loadedPersonData,inputDataPerson:t.inputDataPerson,showSpinnerLoad:t.showSpinnerLoad,searchPersonData:t.searchPersonData,sendNUICallback:t.sendCallback}})],1):t._e(),2==t.site?e("div",{key:t.site,staticClass:"w-full h-full d-flex"},[e("mdt-vehicle",{attrs:{sendNUICallback:t.sendCallback,searchVehicleData:t.searchVehicleData,showSpinnerLoad:t.showSpinnerLoad,inputDataVehicle:t.inputDataVehicle,loadedVehicleData:t.loadedVehicleData}})],1):t._e(),3==t.site?e("div",{key:t.site,staticClass:"w-full h-full d-flex"},[e("mdt-citation",{attrs:{addCitationSuccess:t.addCitationSuccess,citationsData:t.citationsData,inputCitationForm:t.inputCitationForm,sendNUICallback:t.sendCallback,addCitationError:t.addCitationError}})],1):t._e()])],1):t._e()},c=[],d=function(){var t=this,a=t.$createElement,e=t._self._c||a;return e("fragment",[e("div",{staticClass:"sticky-alerts"}),e("nav",{staticClass:"navbar"},[e("div",{staticClass:"navbar-content"}),e("a",{staticClass:"navbar-brand",attrs:{href:"#"}},[t._v(" "+t._s(t.playerData.departmentName)+" ")]),e("div",{staticClass:"navbar-content ml-100"},[e("span",{staticClass:"ml-50"},[e("font-awesome-icon",{attrs:{icon:"user"}})],1),e("span",{staticClass:"ml-5"},[t._v(t._s(t.playerData.name))])]),e("div",{staticClass:"navbar-content ml-110"},[e("span",{staticClass:"ml-50"},[e("font-awesome-icon",{attrs:{icon:"id-badge"}})],1),e("span",{staticClass:"ml-5"},[t._v(t._s(t.playerData.callsign))])]),e("div",{staticClass:"navbar-content ml-110"},[e("span",{staticClass:"ml-50"},[e("font-awesome-icon",{attrs:{icon:"star"}})],1),e("span",{staticClass:"ml-5"},[t._v(t._s(t.playerData.rank))])]),e("div",{staticClass:"navbar-content ml-auto"},[e("div",{staticClass:"progress-group"},[e("div",{staticClass:"progress w-300 h-25"},[e("div",{staticClass:"progress-bar bg-success progress-bar-animated",staticStyle:{"min-width":"0%"},style:{width:t.playerData.xp/2500*100+"%"},attrs:{role:"progressbar","aria-value":"test","aria-valuenow":"50","aria-valuemin":"0","aria-valuemax":"100"}})]),e("span",{staticClass:"progress-group-label"},[e("font-awesome-icon",{staticClass:"text-success font-size-16",attrs:{icon:"arrow-up"}}),t._v("\n          "+t._s(t.playerData.xp)+"/2500 XP\n        ")],1)])]),e("div",{staticClass:"navbar-content"},[e("button",{staticClass:"btn btn-action mr-5",attrs:{type:"button","aria-label":"Włącz dark mode"},on:{click:t.darkMode}},[e("font-awesome-icon",{attrs:{icon:"moon"}})],1)]),e("div",{staticClass:"navbar-content"},[e("button",{staticClass:"btn btn-action mr-5",attrs:{type:"button","aria-label":"Zamknij komputer"},on:{click:t.closeApp}},[e("font-awesome-icon",{staticStyle:{color:"red"},attrs:{icon:"times"}})],1)])])])},u=[],p={props:{darkMode:{type:Function},closeApp:{type:Function},playerData:{type:Object}}},h=p,v=e("2877"),m=Object(v["a"])(h,d,u,!1,null,null,null),C=m.exports,f=function(){var t=this,a=t.$createElement,s=t._self._c||a;return s("fragment",[s("div",{staticClass:"sidebar"},[s("div",{staticClass:"sidebar-menu"},[s("a",{staticClass:"sidebar-brand",attrs:{href:"#"}},[s("img",{staticStyle:{height:"150px","margin-left":"25%"},attrs:{src:e("6d8d")("./department-"+t.playerData.departmentID+".png"),alt:"..."}})]),s("div",{staticClass:"sidebar-content"}),s("h5",{staticClass:"sidebar-title"},[t._v("Baza danych")]),s("div",{staticClass:"sidebar-divider"}),s("a",{staticClass:"sidebar-link",class:{active:1===t.siteNumber},attrs:{href:"#"},on:{click:function(a){return t.changeSite(1)}}},[s("font-awesome-icon",{attrs:{icon:"user"}}),t._v(" Sprawdź osobę")],1),s("a",{staticClass:"sidebar-link",class:{active:2===t.siteNumber},attrs:{href:"#"},on:{click:function(a){return t.changeSite(2)}}},[s("font-awesome-icon",{attrs:{icon:"car"}}),t._v(" Sprawdź pojazd")],1),s("br"),s("h5",{staticClass:"sidebar-title"}),s("div",{staticClass:"sidebar-divider"}),s("a",{staticClass:"sidebar-link",attrs:{href:"#"}},[t._v("Wezwania")]),s("a",{staticClass:"sidebar-link",class:{active:3===t.siteNumber},attrs:{href:"#"},on:{click:function(a){return t.changeSite(3)}}},[s("font-awesome-icon",{attrs:{icon:"pencil-alt"}}),t._v(" Dodaj Wykroczenie")],1),s("a",{staticClass:"sidebar-link",attrs:{href:"#"}},[t._v("Departament")])])])])},b=[],y=(e("c5f6"),{props:{playerData:{type:Object},switchPage:{type:Function},siteNumber:{type:Number}},methods:{changeSite:function(t){this.switchPage(t)}}}),g=y,_=Object(v["a"])(g,f,b,!1,null,null,null),w=_.exports,D=function(){var t=this,a=t.$createElement,e=t._self._c||a;return e("fragment",[e("div",{staticClass:"container-fluid"},[e("div",{staticClass:"row"},[e("div",{staticClass:"col-lg-3"},[e("div",{staticClass:"content"},[e("h1",{staticClass:"content-title"},[t._v("Sprawdź osobę")]),e("form",{staticClass:"w-400 mw-full"},[e("div",{staticClass:"form-group"},[e("label",{attrs:{for:"full-name"}},[t._v("Imię")]),e("input",{directives:[{name:"model",rawName:"v-model",value:t.inputDataPerson.fName,expression:"inputDataPerson.fName"}],staticClass:"form-control",attrs:{type:"text",id:"full-name",placeholder:"Imię",required:"required"},domProps:{value:t.inputDataPerson.fName},on:{input:function(a){a.target.composing||t.$set(t.inputDataPerson,"fName",a.target.value)}}})]),e("div",{staticClass:"form-group"},[e("label",{attrs:{for:"full-name"}},[t._v("Nazwisko")]),e("input",{directives:[{name:"model",rawName:"v-model",value:t.inputDataPerson.lName,expression:"inputDataPerson.lName"}],staticClass:"form-control",attrs:{type:"text",id:"full-name",placeholder:"Nazwisko",required:"required"},domProps:{value:t.inputDataPerson.lName},on:{input:function(a){a.target.composing||t.$set(t.inputDataPerson,"lName",a.target.value)}}})]),e("a",{staticClass:"btn btn-primary",attrs:{role:"button"},on:{click:t.searchPerson}},[e("font-awesome-icon",{attrs:{icon:"search"}}),t._v(" Sprawdź\n              osobę")],1)])])]),t.showSpinnerLoad||t.loadedPersonData||t.personSearchError?t._e():e("div",{staticClass:"col-xl"},[e("div",{staticClass:"card",staticStyle:{"margin-top":"10%"}},[e("h2",{staticClass:"card-title"},[t._v("Brak informacji o osobie")]),e("p",[t._v("Wprowadź dane aby wyszukać osobę")])])]),t.showSpinnerLoad||t.loadedPersonData||!t.personSearchError?t._e():e("div",{staticClass:"col-xl"},[e("div",{staticClass:"card",staticStyle:{"margin-top":"10%"}},[e("h2",{staticClass:"card-title"},[t._v("Nie znaleziono podanej osoby")]),e("p",[t._v("Sprawdź poprawność wpisanych danych i spróbuj ponownie")])])]),t.showSpinnerLoad?e("div",{staticClass:"col-xl"},[e("div",{staticClass:"lds-dual-ring",staticStyle:{left:"40%",position:"absolute",top:"100%"}})]):t._e(),t.loadedPersonData&&t.searchPersonData&&t.searchPersonData.fName?e("div",{staticClass:"col-lg-3"},[e("div",{staticClass:"content"},[e("h1",{staticClass:"content-title"},[t._v("Informacje o osobie")]),e("div",{staticClass:"container-fluid"},[e("div",{staticClass:"row"},[e("div",{staticClass:"col-xl-6"},[e("h3",{staticClass:"font-size-14"},[t._v("Imię")])]),e("div",{staticClass:"col-xl-6"},[e("h3",{staticClass:"font-size-14"},[t._v(t._s(t.searchPersonData.fName))])])]),e("div",{staticClass:"row"},[e("div",{staticClass:"col-xl-6"},[e("h3",{staticClass:"font-size-14"},[t._v("Nazwisko")])]),e("div",{staticClass:"col-xl-6"},[e("h3",{staticClass:"font-size-14"},[t._v(t._s(t.searchPersonData.lName))])])]),e("div",{staticClass:"row"},[e("div",{staticClass:"col-xl-6"},[e("h3",{staticClass:"font-size-14"},[t._v("Data urodzenia")])]),e("div",{staticClass:"col-xl-6"},[e("h3",{staticClass:"font-size-14"},[t._v(t._s(t.searchPersonData.date))])])]),e("div",{staticClass:"row"},[e("div",{staticClass:"col-xl-6"},[e("h3",{staticClass:"font-size-14"},[t._v("Płeć")])]),e("div",{staticClass:"col-xl-6"},["male"==t.searchPersonData.gender?e("h3",{staticClass:"font-size-14"},[t._v("\n                  Mężczyzna\n                ")]):e("h3",{staticClass:"font-size-14"},[t._v("Kobieta")])])]),""!=t.searchPersonData.suspect?e("div",{staticClass:"row"},[e("div",{staticClass:"col-xl-6"},[e("h3",{staticClass:"font-size-14"},[t._v("Poszukiwany listem gończym")])])]):t._e()])])]):t._e(),t.loadedPersonData&&t.searchPersonData?e("div",{staticClass:"col-lg-6"},[e("div",{staticClass:"content"},[e("h1",{staticClass:"content-title"},[t._v("Wypis wykroczeń osoby")]),e("div",{staticClass:"container-fluid"},[t.searchPersonData.citations.length>0?e("div",{staticClass:"table-responsive"},t._l(t.searchPersonData.citationCounter,(function(a,s){return e("span",{key:s,staticClass:"badge-group mr-5",attrs:{role:"group","aria-label":"Wykroczenie"}},[e("a",{staticClass:"badge badge-secondary badge-pill",attrs:{role:"button"}},[t._v(" "+t._s(t.citationConfig[s].citation_desc))]),e("a",{staticClass:"badge bg-dark badge-pill text-light",attrs:{role:"button"}},[t._v("x"+t._s(a))])])})),0):e("h4",[t._v("Brak wykroczeń w bazie danych")])])])]):t._e()]),e("div",{staticClass:"row"},[t.loadedPersonData&&t.searchPersonData&&t.searchPersonData.fName?e("div",{staticClass:"col-lg-3"},[e("div",{staticClass:"content"},[e("h1",{staticClass:"content-title"},[t._v("Dostępne akcje w komputerze")]),e("div",{staticClass:"container-fluid"},[e("a",{staticClass:"btn btn-primary",attrs:{role:"button"},on:{click:function(a){return t.changeSite(3)}}},[e("font-awesome-icon",{attrs:{icon:"pencil-alt"}}),t._v(" Dodaj\n                wykroczenie")],1)])])]):t._e(),t.loadedPersonData&&t.searchPersonData&&t.searchPersonData.fName?e("div",{staticClass:"col-lg-6"},[e("div",{staticClass:"content"},[e("h1",{staticClass:"content-title"},[t._v("Znaczenie kolorów wykroczenia")]),e("div",{staticClass:"container-fluid"},[e("a",{staticClass:"badge badge-success badge-pill mb-5 mr-5",attrs:{role:"button"}},[t._v("Wykroczenie typu niskie")]),e("a",{staticClass:"badge badge-secondary badge-pill mb-5 mr-5",attrs:{role:"button"}},[t._v("Wykroczenie typu średnie")]),e("a",{staticClass:"badge badge-danger badge-pill mb-5",attrs:{role:"button"}},[t._v("Wykroczenie typu wysokie")])])])]):t._e()])])])},k=[],z={props:{citationConfig:{type:Object},inputDataPerson:{type:Object,default:function(){return{fName:"",lName:""}}},sendNUICallback:{type:Function},searchPersonData:{type:Object},personSearchError:{type:Boolean},loadedPersonData:{type:Boolean},showSpinnerLoad:{type:Boolean,default:!1},switchPage:{type:Function}},methods:{searchPerson:function(){this.sendNUICallback("MDT_PersonSearch",this.inputDataPerson,1)},changeSite:function(t){this.switchPage(t)}}},N=z,P=Object(v["a"])(N,D,k,!1,null,null,null),x=P.exports,S=function(){var t=this,a=t.$createElement,e=t._self._c||a;return e("fragment",[e("div",{staticClass:"container-fluid"},[e("div",{staticClass:"row"},[e("div",{staticClass:"col-lg-3"},[e("div",{staticClass:"content"},[e("h1",{staticClass:"content-title"},[t._v("Sprawdź Pojazd")]),e("form",{staticClass:"w-400 mw-full"},[e("div",{staticClass:"form-group"},[e("label",{attrs:{for:"full-name"}},[t._v("Numer Rejestracyjny")]),e("input",{directives:[{name:"model",rawName:"v-model",value:t.inputDataVehicle.plate,expression:"inputDataVehicle.plate"}],staticClass:"form-control",attrs:{type:"text",id:"full-name",placeholder:"Numer Rejestracyjny",required:"required"},domProps:{value:t.inputDataVehicle.plate},on:{input:function(a){a.target.composing||t.$set(t.inputDataVehicle,"plate",a.target.value)}}})]),e("a",{staticClass:"btn btn-primary",attrs:{role:"button"},on:{click:t.searchVehicle}},[e("i",{staticClass:"fa fa-search",attrs:{"aria-hidden":"true"}}),t._v(" Sprawdź\n              pojazd")])])])]),t.showSpinnerLoad||t.loadedVehicleData?t._e():e("div",{staticClass:"col-xl"},[e("div",{staticClass:"card",staticStyle:{"margin-top":"10%"}},[e("h2",{staticClass:"card-title"},[t._v("Brak informacji o pojeździe")]),e("p",[t._v("Wprowadź dane aby wyszukać pojazd")])])]),t.showSpinnerLoad?e("div",{staticClass:"col-xl"},[e("div",{staticClass:"lds-dual-ring",staticStyle:{left:"40%",position:"absolute",top:"100%"}})]):t._e(),t.loadedVehicleData?e("div",{staticClass:"col-lg-9"},[e("div",{staticClass:"content"},[e("h1",{staticClass:"content-title"},[t._v("Informacje o pojeździe")]),e("div",{staticClass:"container-fluid"},[e("div",{staticClass:"row"},[e("div",{staticClass:"col-xl-6"},[e("h3",{staticClass:"font-size-14"},[t._v("Model pojazdu")])]),e("div",{staticClass:"col-xl-6"},[e("h3",{staticClass:"font-size-14"},[t._v(t._s(t.searchVehicleData.modelName))])])]),e("div",{staticClass:"row"},[e("div",{staticClass:"col-xl-6"},[e("h3",{staticClass:"font-size-14"},[t._v("Numer Rejestracyjny")])]),e("div",{staticClass:"col-xl-6"},[e("h3",{staticClass:"font-size-14"},[t._v(t._s(t.searchVehicleData.plate))])])]),e("div",{staticClass:"row"},[e("div",{staticClass:"col-xl-6"},[e("h3",{staticClass:"font-size-14"},[t._v("Kolor")])]),e("div",{staticClass:"col-xl-6"},[e("span",{staticClass:"badge",style:{"background-color":"rgb("+t.searchVehicleData.color[0]+", "+t.searchVehicleData.color[1]+", "+t.searchVehicleData.color[2]+")"}},[t._v("Kolor pojazdu")])])]),e("div",{staticClass:"row"},[e("div",{staticClass:"col-xl-6"},[e("h3",{staticClass:"font-size-14"},[t._v("Przegląd pojazdu")])]),e("div",{staticClass:"col-xl-6"},[t.searchVehicleData.check?e("h3",{staticClass:"font-size-14 text-success"},[t._v("Ważny do "+t._s(t.searchVehicleData.dateOfCheck))]):e("h3",{staticClass:"font-size-14 text-danger"},[t._v("Ważny do "+t._s(t.searchVehicleData.dateOfCheck))])])]),e("div",{staticClass:"row"},[e("div",{staticClass:"col-xl-6"},[e("h3",{staticClass:"font-size-14"},[t._v("Data rejestracji")])]),e("div",{staticClass:"col-xl-6"},[e("h3",{staticClass:"font-size-14"},[t._v(t._s(t.searchVehicleData.dateOfRegistry))])])]),e("div",{staticClass:"row"},[e("div",{staticClass:"col-xl-6"},[e("h3",{staticClass:"font-size-14"},[t._v("Właściciel pojazdu")])]),e("div",{staticClass:"col-xl-6"},[e("h3",{staticClass:"font-size-14"},[t._v(t._s(t.searchVehicleData.fName)+" "+t._s(t.searchVehicleData.lName))])])]),e("div",{staticClass:"row"},[e("div",{staticClass:"col-xl-6"},[e("h3",{staticClass:"font-size-14"},[t._v("Zgłoszenie kradzieży")])]),e("div",{staticClass:"col-xl-6"},[t.searchVehicleData.isStolen?e("h3",{staticClass:"font-size-14 text-danger"},[t._v("Pojazd został skradziony")]):e("h3",{staticClass:"font-size-14 text-success"},[t._v("Brak zgłoszeń")])])])])])]):t._e()])])])},j=[],O={props:{inputDataVehicle:{type:Object},sendNUICallback:{type:Function},searchVehicleData:{type:Object},loadedVehicleData:{type:Boolean},showSpinnerLoad:{type:Boolean,default:!1}},methods:{searchVehicle:function(){this.sendNUICallback("MDT_VehicleSearch",this.inputDataVehicle,2)}}},V=O,F=Object(v["a"])(V,S,j,!1,null,null,null),E=F.exports,L=function(){var t=this,a=t.$createElement,e=t._self._c||a;return e("fragment",[e("div",{staticClass:"container-fluid"},[e("div",{staticClass:"row"},[e("div",{staticClass:"col-lg-12"},[e("div",{staticClass:"content"},[e("h1",{staticClass:"content-title"},[t._v("Dodawanie wykroczenia")]),e("div",{staticClass:"container-fluid"},[e("form",{staticClass:"w-400 mw-full"},[e("div",{staticClass:"form-group"},[e("label",{staticClass:"required",attrs:{for:"fName"}},[t._v("Imię")]),e("input",{directives:[{name:"model",rawName:"v-model",value:t.inputCitationForm.fName,expression:"inputCitationForm.fName"}],staticClass:"form-control",attrs:{type:"text",id:"fName",placeholder:"Imię",required:"required"},domProps:{value:t.inputCitationForm.fName},on:{input:function(a){a.target.composing||t.$set(t.inputCitationForm,"fName",a.target.value)}}})]),e("div",{staticClass:"form-group"},[e("label",{staticClass:"required",attrs:{for:"lName"}},[t._v("Nazwisko")]),e("input",{directives:[{name:"model",rawName:"v-model",value:t.inputCitationForm.lName,expression:"inputCitationForm.lName"}],staticClass:"form-control",attrs:{type:"text",id:"lName",placeholder:"Nazwisko",required:"required"},domProps:{value:t.inputCitationForm.lName},on:{input:function(a){a.target.composing||t.$set(t.inputCitationForm,"lName",a.target.value)}}})]),e("div",{staticClass:"form-group"},[e("label",{staticClass:"required",attrs:{for:"citations"}},[t._v("Wykroczenia")]),e("select",{directives:[{name:"model",rawName:"v-model",value:t.inputCitationForm.citations,expression:"inputCitationForm.citations"}],staticClass:"form-control",attrs:{id:"citations",multiple:"multiple",required:"required",size:"5"},on:{change:function(a){var e=Array.prototype.filter.call(a.target.options,(function(t){return t.selected})).map((function(t){var a="_value"in t?t._value:t.value;return a}));t.$set(t.inputCitationForm,"citations",a.target.multiple?e:e[0])}}},t._l(t.citationsData,(function(a,s){return e("option",{key:s,domProps:{value:s}},[t._v(" "+t._s(a.citation_desc))])})),0),e("div",{staticClass:"form-text"},[t._v("\n      Możesz wybrać kilka wykroczeń przytrzymując lewy "),e("kbd",[t._v("CTRL")])])]),e("div",{staticClass:"form-group"},[e("div",{staticClass:"custom-checkbox"},[e("input",{directives:[{name:"model",rawName:"v-model",value:t.inputCitationForm.agree,expression:"inputCitationForm.agree"}],attrs:{type:"checkbox",id:"agree"},domProps:{checked:Array.isArray(t.inputCitationForm.agree)?t._i(t.inputCitationForm.agree,null)>-1:t.inputCitationForm.agree},on:{change:function(a){var e=t.inputCitationForm.agree,s=a.target,i=!!s.checked;if(Array.isArray(e)){var n=null,o=t._i(e,n);s.checked?o<0&&t.$set(t.inputCitationForm,"agree",e.concat([n])):o>-1&&t.$set(t.inputCitationForm,"agree",e.slice(0,o).concat(e.slice(o+1)))}else t.$set(t.inputCitationForm,"agree",i)}}}),e("label",{attrs:{for:"agree"}},[t._v("Potwierdzam nałożenie mandatu.")])])]),e("div",{staticClass:"form-group"},[""!=t.addCitationError?e("div",{staticClass:"alert alert-danger",attrs:{role:"alert"}},[e("h4",{staticClass:"alert-heading"}),t._v("\n      "+t._s(t.addCitationError)+"\n    ")]):t._e()]),t.addCitationSuccess&&""==t.addCitationError?e("div",{staticClass:"alert alert-success",attrs:{role:"alert"}},[e("h4",{staticClass:"alert-heading"}),t._v("\n    Wykroczenie zostało zapisane w systemie.\n  ")]):t._e(),e("br"),e("a",{staticClass:"btn btn-primary",attrs:{role:"button"},on:{click:t.addCitation}},[t._v("Dodaj wykroczenie")])])])])])])])])},M=[],I={props:{citationsData:{type:Object},inputCitationForm:{type:Object},sendNUICallback:{type:Function},addCitationError:{type:String},addCitationSuccess:{type:Boolean}},methods:{addCitation:function(){this.inputCitationForm.citations=JSON.stringify(this.inputCitationForm.citations),this.sendNUICallback("MDT_addCitation",this.inputCitationForm)}}},W=I,$=Object(v["a"])(W,L,M,!1,null,null,null),q=$.exports,A=(e("96cf"),e("1da1")),U={send:function(){var t=Object(A["a"])(regeneratorRuntime.mark((function t(a){var e,s=arguments;return regeneratorRuntime.wrap((function(t){while(1)switch(t.prev=t.next){case 0:return e=s.length>1&&void 0!==s[1]?s[1]:{},t.next=3,fetch("https://em_pd_mdt/".concat(a),{method:"post",headers:{"Content-type":"application/json; charset=UTF-8"},body:JSON.stringify(e)});case 3:return t.abrupt("return",t.sent);case 4:case"end":return t.stop()}}),t)})));function a(a){return t.apply(this,arguments)}return a}()},B=e("865a");e("fa29"),e("7464"),e("c696");var T={name:"app",components:{"mdt-header":C,"mdt-subheader":w,"mdt-person":x,"mdt-vehicle":E,"mdt-citation":q},data:function(){return{render:!1,site:1,darkModeState:"yes",personSearchError:!1,vehicleSearchError:!1,addCitationError:"",addCitationSuccess:!1,inputDataVehicle:{plate:""},inputCitationForm:{fName:"",lName:"",citations:{},agree:!1},inputDataPerson:{fName:"",lName:""},citationsData:{},showSpinnerLoad:!1,loadedVehicleData:!1,loadedPersonData:!1,searchPersonData:{searched:!1,fName:"",lName:"",date:"",gender:"",driverLicenseExpiry:"",weaponLicense:"",citations:{},citationCounter:{}},searchVehicleData:{isStolen:!1,fName:"",lName:"",dateOfRegistry:"",modelName:"",plate:"",color:{},check:!1,dateOfCheck:""},playerData:{rank:"",xp:0,name:"",departmentID:5,departmentName:"",callsign:""}}},destroyed:function(){window.removeEventListener("message",this.listener)},mounted:function(){var t=this;document.body.setAttribute("data-set-preferred-mode-onload","true"),document.body.style.background="none",B.onDOMContentLoaded(),this.site=1,this.listener=window.addEventListener("message",(function(a){var e=a.data||a.detail;t[e.type]&&t[e.type](e)}))},methods:{darkMode:function(){B.toggleDarkMode()},sendPlayerData:function(t){this.playerData=t.data.playerData,this.citationsData=t.data.citations},renderApp:function(t){document.body.style.background=t?"":"none",this.render=t},closeApp:function(){U.send("closedApp"),document.body.style.background="none",this.render=!1},createdCitation:function(t){this.addCitationError="",this.addCitationSuccess=!1;var a=t.data;"fillall"==a&&(this.addCitationError="Wypełnij wszystkie obowiązkowe pola."),"notfoundperson"==a&&(this.addCitationError="Nie znaleziono osoby o podanym imieniu oraz nazwisku."),"allgood"==a&&(this.addCitationError="",this.addCitationSuccess=!0)},fetchPersonData:function(t){this.showSpinnerLoad=!1,this.personSearchError=!1;var a=t.data;a&&a.fName?(this.searchPersonData=a,this.loadedPersonData=!0):this.personSearchError=!0},fetchVehicleData:function(t){this.showSpinnerLoad=!1,this.vehicleSearchError=!1;var a=t.data;a&&a.fName?(this.searchVehicleData=a,this.loadedVehicleData=!0):this.vehicleSearchError=!0},sendCallback:function(t,a,e){U.send(t,a),console.log({eventName:t,passedData:a}),1!=e&&2!=e||(this.showSpinnerLoad=!0),1==e&&(this.loadedPersonData=!1),2==e&&(this.loadedVehicleData=!1)},switchPage:function(t){this.site=t}}},R=T,J=Object(v["a"])(R,l,c,!1,null,null,null),K=J.exports;n["c"].add(o["i"],o["c"],o["g"],o["a"],o["d"],o["h"],o["e"],o["f"],o["b"]),s["a"].use(i["a"]),s["a"].config.productionTip=!0,s["a"].config.devtools=!0,s["a"].component("font-awesome-icon",r["a"]),new s["a"]({render:function(t){return t(K)}}).$mount("#app")},"6d8d":function(t,a,e){var s={"./department-5.png":"4218"};function i(t){var a=n(t);return e(a)}function n(t){if(!e.o(s,t)){var a=new Error("Cannot find module '"+t+"'");throw a.code="MODULE_NOT_FOUND",a}return s[t]}i.keys=function(){return Object.keys(s)},i.resolve=n,t.exports=i,i.id="6d8d"},7464:function(t,a,e){},c696:function(t,a,e){}});