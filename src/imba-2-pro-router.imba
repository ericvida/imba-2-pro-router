export tag router-tag
	def setup
		@cache = {}

	def render
		<self>
			@cache[@data] ||= imba.createElement(@data,null,null,self)
# <router-tag[R.view]>
# <ref-tag go="/home"> It works just as <a href="">
# <ref-tag view="/home" target="app-root"> 
export tag ref-tag < a
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
export tag switch-tag
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
export tag not-found
	def render
		<self>
			<h1> 'Page not found'

### Marek's notes
Throttle method see in Lodash documentation, it requires second argument
17 says, you can run method once per 17 miniseconds

Generally in my opinion application should have main render method. It can be called by 2 services - router and store.
Both are for the same reason - the data was changed, so the presentation layer should be rerendered to present new information.
There's no other reasons ever the application should be rerendered.
###
