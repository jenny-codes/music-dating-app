// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"
let person_count = 1;

$('.next-button').click(function(){
	$(".person-container:nth-of-type("+person_count+")").css({'left':'-101.5%'});
	$(".person-container:nth-of-type("+(person_count+1)+")").css({'left':'1.5%'});
	person_count+=1;
})

$('.scroll-up').click(function(){
	if($('.album-photos').hasClass('active')){
		$('.person-container').removeClass('active');
		$('.album-photos').removeClass('active');
	}else{
		$('.person-container').addClass('active');
		$('.album-photos').addClass('active')
	}
	console.log($(this).parents()[1])
})
// $('.person-container').touchwipe({
// 	 wipeLeft: function() {
// 	 	$(".person-container:nth-of-type("+person_count+")").css({'left':'-101.5%'});
// 		$(".person-container:nth-of-type("+(person_count+1)+")").css({'left':'1.5%'});
// 		person_count+=1;},
// 	 wipeRight: function() {
// 	 	$(".person-container:nth-of-type("+person_count+")").css({'left':'1.5%'});
// 		$(".person-container:nth-of-type("+(person_count+1)+")").css({'left':'101.5%'});
// 		person_count-=1; }   
// });
// $('.person-container').swiperight(function(){
// 	$(".person-container:nth-of-type("+person_count+")").css({'left':'1.5%'});
// 		$(".person-container:nth-of-type("+(person_count+1)+")").css({'left':'101.5%'});
// 		person_count-=1; 
// })
// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"
