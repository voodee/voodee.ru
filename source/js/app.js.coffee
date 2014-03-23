$(window).load ->
  $('#page-loader').fadeOut()
  $('#preloader').delay(350).fadeOut 'slow'
  $('body').removeClass 'preload'
  

$(document).ready ->
  # Init Scroll
  #skrollr.init forceHeight: false
  # End Init Scroll
  
  # Init of Animate
  new cbpScroller document.getElementById( 'cbp-so-scroller' ) 
  # End of Animate
  
  # Init of AirPort
  #$('.slide-text').airport ['#айдетика', '#дизайн', '#графика', '#музыка', '#фото', '#разработка']
  $('.slide-text').airport ['#identity', '#websites', '#design', '#ios', '#android', '#windowsPhone', '#art', '#graphic', '#printing',  '#seo', '#smm', '#video']
  # End of AirPort
  
  # Init of MainIllustration
  # $('#scene').parallax()
  # End of MainIllustration


  map = new GMaps(
    disableDefaultUI: true
    scrollwheel: false
    el: '#map-canvas'
    lat: 47.226858
    lng: 39.714181
  )
  map.drawOverlay
    lat: map.getCenter().lat()
    lng: map.getCenter().lng()
    layer: 'overlayLayer'
    content: '<div class=\'map-point\'></div>'
    verticalAlign: 'bottom'
    horizontalAlign: 'center'

  styles = [
    elementType: 'labels.icon'
    stylers: [
      weight: 0.3
    ,
      saturation: -100
    ,
      lightness: -25
    ,
      visibility: 'off'
    ]
  ,
    stylers: [
      hue: '#ff8800'
    ,
      weight: 1.6
    ]
  ,
    elementType: 'labels.text.stroke'
    stylers: [visibility: 'simplified']
  ]
  map.addStyle
    styledMapName: 'Styled Map'
    styles: styles
    mapTypeId: 'map_style'

  map.setStyle 'map_style'
  
  $('#map-canvas').append $('<div />').addClass('plane')
  
  # Init menu
  
  open = false
  cnhandle = (e) =>
    e.stopPropagation()
  handler = (e) ->
    e = window.event unless e
    e.stopPropagation()
    unless open
      openNav()
    else
      closeNav()
  openNav = ->
    open = true
    classie.add overlay, "on-overlay"
    classie.add wrapper, "opened-nav"
    classie.remove button, "close"
  closeNav = ->
    open = false
    classie.remove overlay, "on-overlay"
    classie.remove wrapper, "opened-nav"
    classie.add button, "close"
    
  button = document.getElementById("cn-button")
  wrapper = document.getElementById("cn-wrapper")
  overlay = document.getElementById("cn-overlay")

  
  button.addEventListener "click", handler, false
  wrapper.addEventListener "click", cnhandle, false
  
  document.addEventListener "click", closeNav
  
  $('#navigate a').click (e) ->
    e.preventDefault()
    closeNav()
    $('html, body').animate
      scrollTop: $('#' + $(@).data('link')).offset().top
    , 800
    
   
  # Portfolio 
  $('#grid').delegate '[data-load]', 'click', (e) ->
    getPage($(this).data('load'))
    false
    
  # Close Portfolio
  $('#portfolio-window').delegate '.close', 'click', (e) ->
    window.History.pushState {page: 'main'}, 'Хорошие вещи!', '?'
    false
    
  # Open Portfolio
  lastIndex = window.location.href.lastIndexOf('?') + 1
  section = window.location.href.substr lastIndex
  getPage section if lastIndex and section.length
  
  # Tweets
  $.getJSON "http://voodee.ru/tweet/", (data) ->
    $('.twitter').text data.text 
    $('.twitter').linkify()
    moment.lang 'ru'
    $(".twitter-data").text moment(data.created_at).format 'LL'
    
  # uq
  Zenbox.init
    dropboxID: "20236211"
    url: "https://voodee.zendesk.com"
    tabID: "Вопросы"
    tabColor: "black"
    tabPosition: "Right"
    hide_tab: "true"

    
History = window.History
State = History.getState()

getPage = (name) ->
  $.ajax
    url: "img/portfolio/" + name + "/about.json"
    #url: "http://voodee.ru/api/posts/"
    context: document.body
    dataType: "json"
    success: (data) ->
      History.pushState
        page: 'work'
      , 'Хорошие вещи!', '?' + name
      #$('#portfolio-window .work-one').html data
      $('#portfolio-window .work-one').html Mustache.render $("#project").html(), data
      unless Modernizr.csstransitions
        $('#portfolio-window').css('visibility', 'visible').animate
          left: '0'
        , 1000, ->
          $('body').addClass 'open-work'
          $('html, body').css 'overflow', 'hidden'
          $("#portfolio-window").addClass "open loaded"
          $("#portfolio-window .work-one").animate
            opacity: 1
          , 1000

      else
        $("#portfolio-window").addClass "open"
        setTimeout (->
          $('body').addClass 'open-work'
          $('html, body').css 'overflow', 'hidden'
          $("#portfolio-window").addClass "loaded"
          $("#portfolio-window .work-one").animate
            opacity: 1
          , 1000
          if Modernizr.mq("only screen and (max-device-width: 1024px)") and Modernizr.touch
            $("#portfolio-window").niceScroll
              cursorborder: ""
              cursorcolor: "#373334"
              cursorwidth: 8
              boxzoom: false

        ), 1000
        
        $('.project-slider').responsiveSlides()

    error: (data) ->
      $("#portfolio-window").removeClass "open"
      $("#portfolio-window .work-one").html ""

  false
  
  
History.Adapter.bind window, "statechange", ->
  State = History.getState()
  lastIndex = State.cleanUrl.lastIndexOf("=") + 1
  section = State.cleanUrl.substr(lastIndex)
  
  #load if work
  getPage section  if lastIndex and section.length
  
  #close gallery
  if not lastIndex and (State.data.page is "main" or State.data.page is `undefined`)
    unless Modernizr.csstransitions
      $('body').removeClass 'open-work'
      $('html, body').css 'overflow-y', 'auto'
      $("#portfolio-window .work-one").animate
        opacity: 0
      , 1000
      $("#portfolio-window").animate(
        left: "100%"
      , 1000, ->
        $(this).css "visibility", "hidden"
      ).removeClass "loaded open"
    else
      $("#portfolio-window .work-one").animate
        opacity: 0
      , 300
      $("#portfolio-window").removeClass "loaded open"
      $('body').removeClass 'open-work'
      $('html, body').css 'overflow-y', 'auto'
      setTimeout (->
        $("#portfolio-window .work-one").html ""
      ), 500
