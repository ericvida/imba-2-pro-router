import L from 'lodash'
import 'pro-router/standalone'
import {books} from './books'
tag router-tag # has comments
	# <router-tag[R.view]>
	# <ref-tag go="/home"> It works just as <a href="">
	# <ref-tag view="/home" target="app-root">
	def setup
		cache = {}
	def render
		<self>
			cache[data] ||= imba.createElement(data,null,null,self)
tag ref-tag < a
	prop view
	prop target
	prop go
	attr onclick
	def setup
		r = R
	def render
		<self.active=is_active href=link() :click=(do return false)>
			<slot>
	def is_active
		var view, params
		[ view, params ] = r.split_path(link)
		view == r.view && L.isEqual params, r.params
	def ontap e
		return if is_active
		r.go dom:href
		window.scrollTo 0, 0
	def link
		go || url()
	def url
		if target
			var attributes = L.reduce L.concat({}, target), do |map, el|
				map[el.type] = el.id
				map
		r.to_path view, L.defaults attributes || {}, r.safe_params
tag switch-tag
	prop key
	prop isDisabled
	prop isOn
	def setup
		r = R
	def is_on
		r.params[key]
	def ontap
		r.toggle key unless isDisabled
	def render
		<self .is_on=isOn() .disabled=isDisabled()>
			<slot>
tag not-found
	def render
		<self>
			<h1> 'Page not found'
tag home-page
	<self> 
		<h1> "Go Routes"
		<p> "This page was routed using the go property as follows "
			<code> "<route-tag go='/>"
		<p> "it practically behaves the same way "
			<code> "<a href='/' would>"
		<p> "If you notice, the route on your browser goes to the index of your page"
		<p> "You may wonder—How does it know to render the " 
			<code> "<home-page>"
			"?"
		<p>	"In our <app-root> component we have initiated our router with some basic information including which component our app should render on the home route"
		<pre>
			"R.init \n
	helpers: L, \n
	render: L.throttle(self.render.bind(self), 17),  # This uses Lodash.throttle to allow methods to run once every 17 milliseconds. 1000/17 = 60 frames per second. \n
	root: 'home-page', # set your root view \n
	views: ['home-page', 'docs-page', 'about-page', 'books-page'] # set all your views. All others will be 404. \n
			"
		
	### css 
		pre {
			background-color: #2f2f2f;
			color: whitesmoke;
			padding: 20px;
			border-radius: 5px;
			overflow: scroll;
		}
		code {
			background-color: whitesmoke;
			padding: 5px;
			border-radius: 3px;
			letter-spacing: 1px;
			font-family: monospace;
			font-weight: bold;
			color: #2f2f2f;
		}
	###
tag about-page
	<self> 
		<h1> "About Us"
tag docs-page
	<self> 
		<h1> "Learn Something"

let things = [
	id: 0
	type: "book"
	title: "yes"
	author: "mom"
	---
	id: 1
	type: "book"
	title: "no"
	author: "dad"
]
// R.getters.book = do |v| books[v]
R.getters.book = do |v| things[v] 
# R.param('book') is calculated when this getter function is given and cached until the next turn
# this is creating a getter called book, for objects inside the things array.
# NOTE: the things object array must have a parameter called type with a value called book, for R.param('book') to find it.
# R.param('book') is looking for objectes with a parameter `type` that has a value of 'book'

tag books-page
	def render
		<self>
			<.book-links>
				for book in things
					<ref-tag view="books-page" target=book> "book: {book.title}"
			if let boook = R.param('book')
				<div>
					<span> "{boook.id} — "
					<span> "{boook.title} "
					<span> "{boook.author}"
	### css
	books-page > div {
		text-align: center;
	}
	.book-links {
		display: flex;
		justify-content: space-around;
		a {
		background-color: #efefef;
		padding: 10px 5px;
		margin-bottom: 10px;
		flex-grow: 1;
			&:hover {
				background-color: aquamarine;
			}
		}
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
				<ref-tag go="/"> "go route"
				<ref-tag view="docs-page"> "view route"
				<ref-tag to_path="to-page"> "view route"
				<ref-tag view="books-page"> "books"
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


