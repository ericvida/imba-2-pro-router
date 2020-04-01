import 'pro-router/standalone'
import L from 'lodash'
tag router-tag
	def setup
		@cache = {}

	def render
		<self>
			@cache[@data] ||= imba.createElement(@data,null,null,self)
# <router-tag[R.view]>
# <ref-tag go="/home"> It works just as <a href="">
# <ref-tag view="/home" target="app-root">
tag ref-tag < a
	prop view
	prop target
	prop go
	attr onclick
	def setup
		@r = R
	def render
		<self.active=is_active href=link() :click=(do return false)>
			<slot>
	def is_active
		var view, params
		[ view, params ] = @r.split_path(link)
		view == @r.view && L.isEqual params, @r.params
	def ontap e
		return if is_active
		@r.go dom:href
		window.scrollTo 0, 0
	def link
		@go || url()
	def url
		if @target
			var attributes = L.reduce L.concat({}, @target), do |map, el|
				map[el.type()] = el.id()
				map
		@r.to_path @view, L.defaults attributes || {}, @r.safe_params
tag switch-tag
	prop key
	prop isDisabled
	prop isOn
	def setup
		@r = R
	def is_on
		@r.params[key]
	def ontap
		@r.toggle key unless isDisabled
	def render
		<self .is_on=isOn() .disabled=isDisabled()>
			<slot>
tag not-found
	def render
		<self>
			<h1> 'Page not found'
tag home-page
	<self> 
		<h1> "Welcome Home"
tag about-page
	<self> 
		<h1> "About Us"
tag docs-page
	<self> 
		<h1> "Learn Something"
tag books-page
	<self>
		<div #book-1> "book 1"
		<div #book-2> "book 2"
		<div #book-3> "book 3"
	### css
	books-page > div {
		background-color: tomato;
		height: 400px;
		text-align: center;
	}
	###
tag app-root
	def build
		R.init 
			helpers: L, 
			render: L.throttle(self.render.bind(self), 17),  # This uses Lodash.throttle to allow methods to run once every 17 milliseconds. 1000/17 = 60 frames per second.
			root: 'home-page', # set your root view
			views: ['home-page', 'docs-page', 'about-page', 'books-page'] # set all your views. All others will be 404.
	def render
		<self> 
			<h1> "pro-router.js - {R.view}"
			<nav>
				<ref-tag view="home-page"> "home-route"
				<ref-tag view="docs-page"> "docs"
				<ref-tag view="books-page" target={book: 1234}> "book"
				<ref-tag view="wrong-page"> "not-found"
			<router-tag[R.view]>
	### css
	nav {
		display: flex;
		justify-content: space-evenly;
		background-color: #0f0f0f;
		color: white;
		a {
			color: white;
		}
		> * {
			flex: 1;
			text-align: center;
			padding: 10px;
		}
		> *:hover {
			background-color: #3f3f3f;
		}
	}
	###

