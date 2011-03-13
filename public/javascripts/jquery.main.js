$(function(){
	clearInputs();
	initCustomForms();
	initSlideShow();
	initAddFunctional();
	addDocumentFunctional();
	clearInputs($('body'));
	initValidation();
});

function initSlideShow(){
	$('div.gallery').slideshow();
}

function initAddFunctional(){
	$('div.box-step div.add-block').addBlocks();
}

function addDocumentFunctional(){
	$('div.add-document').addDocument();
}

function initValidation(){
	var _errorClass = 'error';
	var _regEmail = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
	
}

//clear inputs
function clearInputs(holder){
	$('input:text, input:password, textarea',holder).each(function(){
		var _el = $(this);
		var _val = _el.val();
		_el.bind('focus', function(){
			if(this.value == _val) this.value = '';
		}).bind('blur', function(){
			if(this.value == '') this.value = _val;
		});
	});
}

$.fn.addDocument = function(){
	return this.each(function(){
		var holder = $(this);
		var radio = $('input:radio',holder);
		var box = $('div.upload-box',holder);
			
		radio.each(function(i){
			var _this = $(this);
			_this.change(function(){
				checkState(i);
			})
			if (_this.is(':checked')) checkState(i);
		});
		
		function checkState(i) {
			box.hide();
			box.eq(i).show();
		}
	});
}

;(function(){
	
var attributeCounter = 0;
$.fn.addBlocks = function(_options){
	
	return this.each(function(){
		var holder = $(this);
		var addLink = $('a.link-add',holder);
		var copyBlock = $('div.default',holder);
		var count = holder.children().length;
		
		function addBlock(){
			var block = copyBlock.clone();
			block.appendTo(holder).removeClass('default');
			block.find('.error').removeClass('error');
			var selects = $('select',block);
			var radios = $('input:radio',block);
			
			attributeCounter++;
			if (selects.length) selects.removeClass('default').customSelect();
			if (radios.length) {
				radios.each(function(){
					var radio = $(this);
					var oldId = radio.attr('id');
					var oldName = radio.attr('name');
					var label = $('label[for='+oldId+']',block);
					
					//set new attr
					radio.attr({'id':oldId+attributeCounter})
					label.attr({'for':oldId+attributeCounter});
				});
				
				$('div.add-document',block).addDocument();
				radios.removeClass('default').customRadio();
			}
			
			var filterArray = [];
			
			$('*',block).each(function(){
				var _this = $(this);
				var name = _this.attr('name');
				if (typeof name != 'undefined' && name.length) {
					filterArray.push(_this);
				}
			});
			
			for (var i = 0; i < filterArray.length; i++) {
				var input = filterArray[i];
				if (typeof input != 'undefined') {
					attributeCounter++;
					if (input.is(':radio')) {
						attributeCounter++;
						var name = input.attr('name');
						for (var j = i; j < filterArray.length; j++) {
							var input2 = filterArray[j];
							if (input2.attr('name') == name) {
								input2.attr('name',input2.attr('name').replace('[0]', '[' + count +']'));
								delete filterArray[j];
							}	
						}
					}
					input.attr('name',input.attr('name').replace('[0]', '[' + count +']'));
				}
			}			
						
			clearInputs(block);
			bindDelete(block);
		}
		
		function bindDelete(block){
			var closer = $('a.link-minus',block);
			closer.click(function(e){
			  if($(this).attr('href') != '#'){
			    block.replaceWith("<input type='hidden' name='" + $(this).attr('href').substr(1) + "' value=1 />");
			  } else {
  				block.remove();
  			}
				return false;
			});
		}
		
		addLink.click(function(e){
			addBlock();
			return true;
		});
	});
}

})();

//create jQuery plugin
$.fn.slideshow = function(options){return new slideshow(this, options);}

//constructor
function slideshow(obj, options){this.init(obj,options)}

//prototype
slideshow.prototype = {
	init:function(obj, options) {
		this.options = $.extend({
			slides:'div.gallery-inf > ul >li',
			nextBtn:'a.next',
			prevBtn:'a.prev',
			pagingHolder:'div.swicher',
			pagingTag:'li',
			createPaging:true,
			autoPlay:true,
			dynamicLoad:false,
			imgAttr:'alt',
			effect:'slideX',//fade, slideX, slideY,
			startSlide:false,
			switchTime:5000,
			animSpeed:700
		},options);
		
		this.mainHolder = $(obj);
		this.slides = $(this.options.slides,this.mainHolder);		
		this.nextBtn = $(this.options.nextBtn,this.mainHolder);
		this.prevBtn = $(this.options.prevBtn,this.mainHolder);
		this.dynamicLoad = this.options.dynamicLoad;
		this.imgAttr = this.options.imgAttr;
		this.animSpeed = this.options.animSpeed;
		this.switchTime = this.options.switchTime;
		this.effect = this.options.effect;
		this.autoPlay = this.options.autoPlay;
		this.previous = -1;
		this.loadingFrame = 1;
		this.busy = false;
		this.direction = 1;
		this.timer;
		this.pagingArray = new Array;
		this.loadArray = new Array;
		this.preloader = new Array;
		this.slidesParent = this.slides.eq(0).parent();
		this.slideW = this.slidesParent.width();
		this.slideH = this.slidesParent.height();
		
		(function(){
			if (this.options.startSlide) this.current = this.options.startSlide
			else {
				var active = -1;
				for(var i = 0; i< this.slides.length-1; i++) {
					if (this.slides.eq(i).hasClass('active')) {
						active = i;
						break;						
					}
				}
				if (active != -1) this.current = active;
				else this.current = 0;
			}
		}).apply(this);
		
		this.initPaging();
		this.setStyles();
		this.bindEvents();
		this.showSlide();
	},
	
	initPaging:function(){
		var obj = this;
		this.pagingHolder = $(this.options.pagingHolder,this.mainHolder);
		
		if (this.options.createPaging) {
			this.pagingHolder.each(function(i){
				var _this = $(this);
				_this.empty();
				var list = $('<ul>');
				for (var i = 0; i < obj.slides.length; i++) $('<li><a href="#">' + (i + 1) + '</a></li>').appendTo(list);
				_this.append(list);
			});
		}
		
		this.paging = $(this.options.pagingTag, this.pagingHolder);
		var ratio = Math.ceil(this.paging.length / this.slides.length);
		for (var i = 0; i < ratio; i++) {
			this.pagingArray.push(this.paging.slice(i*this.slides.length, (i*this.slides.length)+this.slides.length));
		}
	},
	
	setStyles:function(){
		//loader
		if (this.dynamicLoad) {
			this.loader = $('<div class="loader">');
			this.loaderDiv = $('<div>').appendTo(this.loader)
			this.loader.append(this.loaderDiv).appendTo(this.slidesParent);
		}
		
		//slides
		if (this.effect == 'fade') {
			this.slides.css({display:'none'});
			this.slides.eq(this.current).css({display:'block'});
		} else if (this.effect == 'slideX'){
			this.slides.css({display: 'none',left:-this.slideW});
			this.slides.eq(this.current).css({display:'block',left:0});
		} else if (this.effect == 'slideY'){
			this.slides.css({display:'none',top:-this.slideH});
			this.slides.eq(this.current).css({display:'block',top:0});
		}
	},
	
	bindEvents:function(){
		var obj = this;
		this.nextBtn.bind('click',function(){
			if (!obj.busy) obj.nextSlide();
			return false;
		});
		
		this.prevBtn.bind('click',function(){
			if (!obj.busy) obj.prevSlide();
			return false;
		});
		
		for (var i = 0; i < this.pagingArray.length; i++) {
			this.pagingArray[i].each(function(i){
				$(this).bind('click',function(){
					if (i != obj.current && !obj.busy) {
						obj.previous = obj.current;
						obj.current = i;
						if (obj.previous > i) obj.direction = -1
						else obj.direction = 1;
						obj.showSlide();
					}
					return false;
				});
			});
		}
		
		if (this.dynamicLoad) this.loader.bind('click',function(){
			obj.abortLoading();
		});
	},
	
	nextSlide:function(){
		this.previous = this.current;
		if (this.current < this.slides.length-1) this.current++
		else this.current = 0;
		this.direction = 1;
		this.showSlide();
	},
	
	prevSlide:function(){
		this.previous = this.current;
		if (this.current > 0) this.current--
		else this.current = this.slides.length-1;
		this.direction = -1;
		this.showSlide();
	},
	
	showSlide:function(){
		var obj = this;
		var _current = this.current;
		this.busy = true;
		clearTimeout(this.timer);
		
		if (typeof this.loadArray[_current] != 'undefined' || !this.dynamicLoad) {
			//slide already loaded
			this.switchSlide();
		
		} else {
			//slide not loaded
			this.showLoading();
			var images = $(this.dynamicLoad,this.slides.eq(this.current));
			if (images.length) {
				var counter = 0;
				images.each(function(){
					var preloader = new Image;
					obj.preloader.push(preloader);
					var img = $(this);
					preloader.onload = function(){
						counter++;
						checkImages();
					}
					preloader.onerror = function(){
						//ignore errors
						counter++;
						checkImages();
					}
					preloader.src = img.attr(obj.imgAttr);
				});
				
				function checkImages(){
					if (counter == images.length) {
						images.each(function(){
							var img = $(this);
							img.attr('src',img.attr(obj.imgAttr));
						});
						successLoad();
					}
				}
				
			} else successLoad();
		}
		
		function successLoad(){
			obj.loadArray[_current] = 1;
			obj.hideLoading();
			obj.switchSlide();
		}
	},
	
	switchSlide:function(){
		var obj = this;
		
		if (this.previous != -1) {
			var nextSlide = this.slides.eq(this.current);
			var prevSlide = this.slides.eq(this.previous);
			
			if (this.effect == 'fade') {
				nextSlide.css({display:'block',opacity:0}).animate({opacity:1},this.animSpeed,function(){
					$(this).css({opacity:'auto'});
				});
				prevSlide.animate({opacity:0},this.animSpeed,callback);
			} else if (this.effect == 'slideX'){
				nextSlide.css({display:'block',left:this.slideW*this.direction}).animate({left:0},this.animSpeed);
				prevSlide.animate({left:-this.slideW*this.direction},this.animSpeed+10,callback);
			} else if (this.effect == 'slideY'){
				nextSlide.css({display:'block',top:this.slideH*this.direction}).animate({top:0},this.animSpeed);
				prevSlide.animate({top:-this.slideH*this.direction},this.animSpeed+10,callback);
			}
		} else {
			if (this.autoPlay) this.startAutoPlay();
			this.busy = false;
		}
		
		this.refreshStatus();
		
		function callback(){
			prevSlide.css({display:'none'});
			if (obj.autoPlay) obj.startAutoPlay();
			obj.busy = false;
		}
	},
	
	refreshStatus:function(){
		for (var i = 0; i < this.pagingArray.length;i++) {
			this.pagingArray[i].eq(this.previous).removeClass('active');
			this.pagingArray[i].eq(this.current).addClass('active');
		}
		this.slides.eq(this.previous).removeClass('active');
		this.slides.eq(this.current).addClass('active');
	},
	
	showLoading:function(){
		var obj = this;
		this.loader.show();
		clearInterval(this.loadingTimer);
		obj.loadingTimer = setInterval(animateLoading, 66);
		
		function animateLoading(){
			obj.loaderDiv.css('top', obj.loadingFrame * -40);
			obj.loadingFrame = (obj.loadingFrame + 1) % 12;
		}
	},
	
	hideLoading:function(){
		this.loader.hide();
		clearInterval(this.loadingTimer);
	},
	
	abortLoading:function(){
		this.busy = false;
		this.hideLoading();
		this.current = this.previous;
		for (var i = 0; i < this.preloader.length; i++) {
			this.preloader[i].onload = null;
			this.preloader[i].onerror = null;
		}
		if (this.autoPlay) this.startAutoPlay();
	},
	
	startAutoPlay:function(){
		var obj = this;
		clearTimeout(obj.timer);
		obj.timer = setTimeout(function(){
			obj.nextSlide();
		},obj.switchTime);
	}
}

// custom forms init
function initCustomForms() {
	$('select').customSelect();
	$('input:radio').customRadio();
	$('input:checkbox').customCheckbox();
}

// custom forms plugin
;(function(jQuery){
	// custom checkboxes module
	jQuery.fn.customCheckbox = function(_options){
		var _options = jQuery.extend({
			checkboxStructure: '<div></div>',
			checkboxDisabled: 'disabled',
			checkboxDefault: 'checkboxArea',
			checkboxChecked: 'checkboxAreaChecked',
			filterClass:'default'
		}, _options);
		return this.each(function(){
			var checkbox = jQuery(this);
			if(!checkbox.hasClass('outtaHere') && checkbox.is(':checkbox') && !checkbox.hasClass(_options.filterClass)){
				var replaced = jQuery(_options.checkboxStructure);
				this._replaced = replaced;
				if(checkbox.is(':disabled')) replaced.addClass(_options.checkboxDisabled);
				else if(checkbox.is(':checked')) replaced.addClass(_options.checkboxChecked);
				else replaced.addClass(_options.checkboxDefault);

				replaced.click(function(){
					if(checkbox.is(':checked')) checkbox.removeAttr('checked');
					else checkbox.attr('checked', 'checked');
					changeCheckbox(checkbox);
				});
				checkbox.click(function(){
					changeCheckbox(checkbox);
				});
				replaced.insertBefore(checkbox);
				checkbox.addClass('outtaHere');
			}
		});
		function changeCheckbox(_this){
			_this.change();
			if(_this.is(':checked')) _this.get(0)._replaced.removeClass().addClass(_options.checkboxChecked);
			else _this.get(0)._replaced.removeClass().addClass(_options.checkboxDefault);
		}
	}

	// custom radios module
	jQuery.fn.customRadio = function(_options){
		var _options = jQuery.extend({
			radioStructure: '<div></div>',
			radioDisabled: 'disabled',
			radioDefault: 'radioArea',
			radioChecked: 'radioAreaChecked',
			filterClass:'default'
		}, _options);
		return this.each(function(){
			var radio = jQuery(this);
			if(!radio.hasClass('outtaHere') && radio.is(':radio') && !radio.hasClass(_options.filterClass)){
				var replaced = jQuery(_options.radioStructure);
				this._replaced = replaced;
				if(radio.is(':disabled')) replaced.addClass(_options.radioDisabled);
				else if(radio.is(':checked')) replaced.addClass(_options.radioChecked);
				else replaced.addClass(_options.radioDefault);
				replaced.click(function(){
					if(jQuery(this).hasClass(_options.radioDefault)){
						radio.attr('checked', 'checked');
						changeRadio(radio.get(0));
					}
				});
				radio.click(function(){
					changeRadio(this);
				});
				replaced.insertBefore(radio);
				radio.addClass('outtaHere');
			}
		});
		function changeRadio(_this){
			jQuery(_this).change();
			jQuery('input:radio[name='+jQuery(_this).attr("name")+']').not(_this).each(function(){
				if(this._replaced && !jQuery(this).is(':disabled')) this._replaced.removeClass().addClass(_options.radioDefault);
			});
			_this._replaced.removeClass().addClass(_options.radioChecked);
		}
	}

	// custom selects module
	jQuery.fn.customSelect = function(_options) {
		var _options = jQuery.extend({
			selectStructure: '<div class="selectArea"><span class="left"></span><span class="center"></span><a href="#" class="selectButton"></a><div class="disabled"></div></div>',
			hideOnMouseOut: false,
			copyClass: true,
			selectText: '.center',
			selectBtn: '.selectButton',
			selectDisabled: '.disabled',
			optStructure: '<div class="optionsDivVisible"><div class="select-top"></div><div class="select-center"><ul></ul><div class="select-bottom"></div></div>',
			optList: 'ul',
			filterClass:'default'
		}, _options);
		return this.each(function() {
			var select = jQuery(this);
			if(!select.hasClass('outtaHere') && !select.hasClass(_options.filterClass)) {
				if(select.is(':visible')) {
					var hideOnMouseOut = _options.hideOnMouseOut;
					var copyClass = _options.copyClass;
					var replaced = jQuery(_options.selectStructure);
					var selectText = replaced.find(_options.selectText);
					var selectBtn = replaced.find(_options.selectBtn);
					var selectDisabled = replaced.find(_options.selectDisabled).hide();
					var optHolder = jQuery(_options.optStructure);
					var optList = optHolder.find(_options.optList);
					if(copyClass) optHolder.addClass('drop-'+select.attr('class'));

					if(select.attr('disabled')) selectDisabled.show();
					select.find('option').each(function(){
						var selOpt = jQuery(this);
						var _opt = jQuery('<li><a href="#">' + selOpt.html() + '</a></li>');
						if(selOpt.attr('selected')) {
							selectText.html(selOpt.html());
							_opt.addClass('selected');
						}
						_opt.children('a').click(function() {
							optList.find('li').removeClass('selected');
							select.find('option').removeAttr('selected');
							jQuery(this).parent().addClass('selected');
							selOpt.attr('selected', 'selected');
							selectText.html(selOpt.html());
							select.change();
							optHolder.hide();
							return false;
						});
						optList.append(_opt);
					});
					replaced.width(select.outerWidth());
					replaced.insertBefore(select);
					optHolder.css({
						width: select.outerWidth(),
						display: 'none',
						position: 'absolute'
					});
					jQuery(document.body).append(optHolder);

					var optTimer;
					replaced.hover(function() {
						if(optTimer) clearTimeout(optTimer);
					}, function() {
						if(hideOnMouseOut) {
							optTimer = setTimeout(function() {
								optHolder.hide();
							}, 200);
						}
					});
					optHolder.hover(function(){
						if(optTimer) clearTimeout(optTimer);
					}, function() {
						if(hideOnMouseOut) {
							optTimer = setTimeout(function() {
								optHolder.hide();
							}, 200);
						}
					});
					selectBtn.click(function() {
						if(optHolder.is(':visible')) {
							optHolder.hide();
						}
						else{
							if(_activeDrop) _activeDrop.hide();
							optHolder.find('ul').css({height:'auto', overflow:'hidden'});
							optHolder.css({
								top: replaced.offset().top + replaced.outerHeight(),
								left: replaced.offset().left,
								display: 'block'
							});
							if(optHolder.find('ul').height() > 200) optHolder.find('ul').css({height:200, overflow:'scroll'});
							_activeDrop = optHolder;
						}
						return false;
					});
					replaced.addClass(select.attr('class'));
					select.addClass('outtaHere');
				}
			}
		});
	}

	// event handler on DOM ready
	var _activeDrop;
	jQuery(function(){
		jQuery('body').click(hideOptionsClick)
		jQuery(window).resize(hideOptions)
	});
	function hideOptions() {
		if(_activeDrop && _activeDrop.length) {
			_activeDrop.hide();
			_activeDrop = null;
		}
	}
	function hideOptionsClick(e) {
		if(_activeDrop && _activeDrop.length) {
			var f = false;
			jQuery(e.target).parents().each(function(){
				if(this == _activeDrop) f=true;
			});
			if(!f) {
				_activeDrop.hide();
				_activeDrop = null;
			}
		}
	}
})(jQuery);
