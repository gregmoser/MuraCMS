<!---
	
    Slatwall - An Open Source eCommerce Platform
    Copyright (C) 2011 ten24, LLC
	
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
	
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
	
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
	
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.
	
Notes: 
	
--->

<!--- This header include should be changed to the header of your site.  Make sure that you review the header to include necessary JS elements for slatwall templates to work ---> 
<cfinclude template="_slatwall-header.cfm" />

<!--- This import allows for the custom tags required by this page to work --->
<cfimport prefix="sw" taglib="/Slatwall/public/tags" />

<!---[DEVELOPER NOTES]															
																				
	If you would like to customize any of the public tags used by this			
	template, the recommended method is to uncomment the below import,			
	copy the tag you'd like to customize into the directory defined by			
	this import, and then reference with swc:tagname instead of sw:tagname.		
	Technically you can define the prefix as whatever you would like and use	
	whatever directory you would like but we recommend using this for			
	the sake of convention.														
																				
	<cfimport prefix="swc" taglib="/Slatwall/custom/public/tags" />				
																				
--->

<cfoutput>
	<div class="container">
		
		<div class="row">
			<div class="span12">
				<!--- We use the getTitle() method which uses the title template setting to pull in brand name or whatever else you might want in your titles --->
				<h2>#$.slatwall.product().getTitle()#</h2>
			</div>
		</div>
		<div class="row">
			<div class="span4">
				<div class="well">
					<!--- This displays the primary image which is pulled from the default sku --->
					<a href="#$.slatwall.product().getImagePath()#" target="_blank">#$.slatwall.product().getImage(size="m")#</a>
				</div>
			</div>
			<div class="span8">
				<div class="row">
					<div class="span5">
						<!--- START: PRODUCT DETAILS EXAMPLE --->
						<h4>Product Details Example</h4>
						<dl class="dl-horizontal">
							<!--- Product Code --->
							<dt>Product Code</dt>
							<dd>#$.slatwall.product().getProductCode()#</dd>
							
							<!--- Product Type --->
							<dt>Product Type</dt>
							<dd>#$.slatwall.product().getProductType().getProductTypeName()#</dd>
							
							<!--- Brand --->
							<cfif !isNull($.slatwall.product().getBrand())>
								<dt>Product Type</dt>
								<dd>#$.slatwall.product().getBrand().getBrandName()#</dd>
							</cfif>
							
							<!--- List Price | This price is really just a place-holder type of price that can display the MSRP.  It is typically used to show the highest price --->
							<dt>List Price</dt>
							<dd>#$.slatwall.product().getFormattedValue('listPrice')#</dd>
							
							<!--- Current Account Price | This price is used for accounts that have Price Groups associated with their account.  Typically Price Groups are used for Wholesale pricing, or special employee / account pricing --->
							<dt>Current Account Price</dt>
							<dd>#$.slatwall.product().getFormattedValue('currentAccountPrice')#</dd>
							
							<!--- Sale Price | This value will be pulled from any current active promotions that don't require any promotion qualifiers or promotion codes --->
							<dt>Sale Price</dt>
							<dd>#$.slatwall.product().getFormattedValue('salePrice')# </dd>
							
							<!--- Live Price | The live price looks at both the salePrice and currentAccountPrice to figure out which is better and display that.  This is what the customer will see in their cart once the item has been added so it should be used as the primary price to display --->
							<dt>Live Price</dt>
							<dd>#$.slatwall.product().getFormattedValue('livePrice')# </dd>
							
							<!--- Product Description --->
							<dt>Product Description</dt>
							<dd>#$.slatwall.product().getProductDescription()# &nbsp;</dd>
						</dl>
						<!--- END: PRODUCT DETAILS EXAMPLE --->
					</div>
					<div class="span3">
						<!--- Start: PRICE DISPLAY EXAMPLE --->
						<h4>Price Display Example</h4>
						<br />
						<cfif $.slatwall.product('price') gt $.slatwall.product('livePrice')>
							<span style="text-decoration:line-through;color:##cc0000;">#$.slatwall.product().getFormattedValue('price')#</span><br />
							<span style="font-size:24px;color:##333333;">#$.slatwall.product().getFormattedValue('livePrice')#</span>		
						<cfelse>
							<span style="font-size:24px;color:##333333;">#$.slatwall.product().getFormattedValue('livePrice')#</span>
						</cfif>
						<!---[ DEVELOPER NOTES ]														
																										
								When asking for a price from a product, it automatically pulls			
								that price from whichever has been defined as the 'Default Sku'			
								in the admin.  If your skus have different prices, you will either		
								want to update the price based on the sku selected in an addToCart		
								form, or you might want to put the price in the dropdowns themselves.	
								Another option would be to use the type of AddToCart form that lists	
								out all of the skus.													
																										
						--->
						<!--- END: PRICE DISPLAY EXAMPLE --->
					</div>
				</div>
				
				<hr />
				
				<!--- START: ADD TO CART EXAMPLE 1 --->
				<h4>Add To Cart Form Example 1</h4>
				
				<!--- Start of form, note that the action can be set to whatever URL you would like the user to end up on. ---> 
				<form action="?s=1" method="post">
					<input type="hidden" name="slatAction" value="public:cart.addOrderItem" />
					
					<!---[ DEVELOPER NOTES ]																				
																															
						$.slatwall.product().getSkus() returns all of the skus for a product								
					 																										
					 	sorted = true | allows for the list to be sorted based on the optionGroup and option sort order		
						fetchOptions = true | optimizes the query to pull down the option details to be displayed			
																															
					--->
					<cfset local.skus = $.slatwall.product().getSkus(sorted=true, fetchOptions=true) />
						
					<!--- Check to see if there are more than 1 skus, if so then display the options dropdown --->
					<cfif arrayLen(local.skus) gt 1>
						
						<!--- Sku Selector --->
						<select name="skuID" class="required">
							
							<!--- Blank option to force user to select (this is optional) --->	
							<option value="">Select Option</option>
							
							<!--- Loop over the skus to display options --->
							<cfloop array="#local.skus#" index="local.sku">
								<!--- This provides an option for each sku, with the 'displayOptions' method to show the optionGroup / option names --->
								<option value="#local.sku.getSkuID()#">#local.sku.displayOptions()#</option>
							</cfloop>
							
						</select>
						
						<br />
						
					<!--- If there are only 1 skus, then add a hidden field --->
					<cfelse> 
						<input type="hidden" name="skuID" value="#$.slatwall.product().getDefaultSku().getSkuID()#" />
					</cfif>
					
					<!--- Add to Cart Button --->
					<button type="submit" class="btn">Add To Cart</button>
				</form>
				<!--- END: ADD TO CART EXAMPLE 1 --->
				
			</div>
		</div>
		
		<!--- Lower Section --->
		<hr />
		
		<!--- Start: Add Product Review Example --->
		<div class="row">
			
			<div class="span12">
				
				<h4>Product Review Example</h4>
				
				<div class="row">
					
					<div class="span6">
						
						<!---[DEVELOPER NOTES]																
																											
							We recommend setting up an email for "Product Reviews" that will go to someone	
							in the organization whenever a new product review is created.  You can add an	
							Event trigger for "Product" and create an event trigger on:						
							"Product - After Add Product Review Success" 									
																											
						--->
						
						<!--- Get the existing product reviews smart list --->
						<cfset productReviewsSmartList = $.slatwall.product().getProductReviewsSmartList() />
						
						<!--- Make sure that only 'active' product reviews are shown --->
						<cfset productReviewsSmartList.addFilter('activeFlag', true) />
						
						<!--- Set it up to be able to show 100 product reviews --->
						<cfset productReviewsSmartList.setPageRecordsShow(100) />
						
						<!--- Check to see if there are any product reviews --->
						<cfif productReviewsSmartList.getRecordsCount()>
						
							<!--- Loop Over All Existing product reviews --->
							<cfloop array="#productReviewsSmartList.getPageRecords()#" index="productReview">
								
								<!--- Each Review --->
								<article>
									
									<!--- Show Title and Rating Stars --->
									<h5>#productReview.getReviewTitle()#
										<cfif not isNull(productReview.getRating()) and productReview.getRating() gt 0>
											<i class="icon-star"></i>
											<cfif productReview.getRating() gte 2>
												<i class="icon-star"></i>
											</cfif>
											<cfif productReview.getRating() gte 3>
												<i class="icon-star"></i>
											</cfif>
											<cfif productReview.getRating() gte 4>
												<i class="icon-star"></i>
											</cfif>
											<cfif productReview.getRating() gte 5>
												<i class="icon-star"></i>
											</cfif>
										</cfif>
									</h5>
		
									<!--- Show the reviewer info --->
									<h6>
										<cfif not isNull(productReview.getReviewerName()) and len(productReview.getReviewerName())>
											<em>#productReview.getReviewerName()#</em>
										<cfelse>
											<em>Anonymous</em>
										</cfif>
									</h6>
									
									<!--- Show the actual Review --->
									<p>#productReview.getFormattedValue('review')#</p>
									
								</article>
								
								<hr style="border-top-style:dashed;" />
							</cfloop>
							
						<cfelse>
							
							<p>The are currently no reviews for this product, be the first!</p>
							
						</cfif>
						
					</div>
				
					<div class="span6">
						
						<!--- Start: Add Product Review Form --->
						<h5 style="text-align:center;">Add Product Review</h5>
						
						<!--- Check to see if this was just submitted successfully --->
						<cfif $.slatwall.hasSuccessfulAction( "public:product.addProductReview" )>
							
							<!--- Show success Message --->
							<p class="success">Your product review was successfully added. <cfif not $.slatwall.product().setting('productAutoApproveReviewsFlag')>Please note that products reviews are reviewed by our staff before being published to the site.</cfif></p>
							
						<cfelse>
							
							<!--- Get the addProductReview process object, this allows any validation to come across with it --->
							<cfset addProductReviewObj = $.slatwall.product().getProcessObject('addProductReview') />
							
							<!--- Error Display: This will show all of the errors of the addProductReview if it was submitted and has some --->
							<sw:errorDisplay object="#addProductReviewObj.getNewProductReview()#" />
							
							<!--- Add Product Review Form --->
							<form action="?s=1" method="post" class="form-horizontal">
								
								<!--- This hidden input is what tells slatwall to add the contents submitted --->
								<input type="hidden" name="slatAction" value="public:product.addProductReview" />
								
								<!--- This hidden field is what attaches the review to the actual product and it is required for this form to work --->
								<input type="hidden" name="newProductReview.product.productID" value="#$.slatwall.product().getProductID()#" />
								
								<!--- This is just required so that it will populate correctly --->
								<input type="hidden" name="newProductReview.productReviewID" value="" />
								
								<!--- Rating --->
								<div class="control-group">
			    					<label class="control-label" for="rating">Rating</label>
			    					<div class="controls">
			    						
										<!--- This select box allows you to add ratings along with your review, but it is not required.  If you would just like to do ratings that is fine too --->
										<sw:formField type="select" name="newProductReview.rating" valueObject="#addProductReviewObj.getNewProductReview()#" valueOptions="#addProductReviewObj.getNewProductReview().getRatingOptions()#" valueObjectProperty="rating" />
										<sw:errorDisplay object="#addProductReviewObj.getNewProductReview()#" errorName="rating" />
										
			    					</div>
			  					</div>
								
								<!--- Reviewer Name --->
								<div class="control-group">
			    					<label class="control-label" for="reviewTitle">Reviewer Name</label>
			    					<div class="controls">
			    						
										<!--- Little bit of logic to set the default reviewers name to the current account if they are logged in.  This is totally optional --->
										<cfif isNull(addProductReviewObj.getNewProductReview().getReviewerName()) and $.slatwall.getLoggedInFlag()>
											<cfset addProductReviewObj.getNewProductReview().setReviewerName( $.slatwall.getAccount().getFullName() ) />
			    						</cfif>
										
			    						<!--- This form field allows you to let users add titles to reviews, but it is not required --->
										<sw:formField type="text" name="newProductReview.reviewerName" valueObject="#addProductReviewObj.getNewProductReview()#" valueObjectProperty="reviewerName" />
										<sw:errorDisplay object="#addProductReviewObj.getNewProductReview()#" errorName="reviewerName" />
										
			    					</div>
			  					</div>
								
								<!--- Review Title --->
								<div class="control-group">
			    					<label class="control-label" for="reviewTitle">Review Title</label>
			    					<div class="controls">
			    						
			    						<!--- This form field allows you to let users add titles to reviews, but it is not required --->
										<sw:formField type="text" name="newProductReview.reviewTitle" valueObject="#addProductReviewObj.getNewProductReview()#" valueObjectProperty="reviewTitle" />
										<sw:errorDisplay object="#addProductReviewObj.getNewProductReview()#" errorName="reviewTitle" />
										
			    					</div>
			  					</div>
								
								<!--- Review --->
								<div class="control-group">
			    					<label class="control-label" for="review">Review</label>
			    					<div class="controls">
			    						
			    						<!--- This input is the primary review section, but it is also not required by default --->
										<sw:formField type="textarea" name="newProductReview.review" valueObject="#addProductReviewObj.getNewProductReview()#" valueObjectProperty="review" />
										<sw:errorDisplay object="#addProductReviewObj.getNewProductReview()#" errorName="review" />
										
										
			    					</div>
			  					</div>
								
								<!--- Submit Button --->
								<div class="control-group">
			    					<div class="controls">
			      						<button type="submit" class="btn">Add Review</button>
			    					</div>
			  					</div>
								
							</form>
							<!--- End: Add Product Review Form --->
							
						</cfif>
						
					</div>
				</div>
			</div>
		</div>
		<!--- End: Add Product Review Example --->
		
		
		<hr />
			
		<!--- Start: Related Products Example --->
		<div class="row">
			<div class="span12">
				
				<h4>Related Products Example</h4>
				
				<div class="well">
						
					<!--- Get the related products smart list --->
					<cfset relatedProductsSmartList = $.slatwall.product().getRelatedProductsSmartList() />
					
					<!--- Setting this to only show 4 --->
					<cfset relatedProductsSmartList.setPageRecordsShow(4) />
					
					<!--- Adding fliter to only show active / published products --->
					<cfset relatedProductsSmartList.addFilter('activeFlag', 1) />
					<cfset relatedProductsSmartList.addFilter('publishedFlag', 1) />
					
					<!--- Verify that there are records --->
					<cfif relatedProductsSmartList.getRecordsCount()>
						<ul class="thumbnails">
							
							<!--- Promary loop for each related product --->
							<cfloop array="#relatedProductsSmartList.getPageRecords()#" index="product">
								
								<!--- Individual Product --->
								<li class="span3">
									
									<div class="thumbnail">
										
										<!--- Product Image --->
										<img src="#product.getResizedImagePath(size='m')#" alt="#product.getCalculatedTitle()#" />
										
										<!--- The Calculated Title allows you to setup a title string as a dynamic setting.  When you call getTitle() it generates the title based on that title string setting. To be more perfomant this value is cached as getCalculatedTitle() ---> 
										<h5>#product.getCalculatedTitle()#</h5>
			      						
										<!--- Check to see if the products price is > the sale price.  If so, then display the original price with a line through it --->
										<cfif product.getPrice() gt product.getCalculatedSalePrice()>
											<p><span style="text-decoration:line-through;">#product.getPrice()#</span> <span class="text-error">#product.getFormattedValue('calculatedSalePrice')#</span></p>
										<cfelse>
											<p>#product.getFormattedValue('calculatedSalePrice')#</p>	
										</cfif>
										
										<!--- This is the link to the product detail page.  sense we aren't on a listing page you should always just use the standard getProductURL() --->
										<a href="#product.getProductURL()#">Details / Buy</a>
										
									</div>
								</li>
							</cfloop>
						</ul>
					<cfelse>
						<p>There are no related products.</p>
					</cfif>
				</div>
			</div>
		</div>
		<!--- End: Related Products Example --->
		
		<hr />
		
		<!--- Start: Image Gallery Example --->
		<div class="row">
			<div class="span12">
				<h4>Image Gallery Example</h4>
				
				<cfset local.galleryDetails = $.slatwall.product().getImageGalleryArray() />
				
				<!---[ DEVELOPER NOTES ]																		
																												
					The primary method that makes images galleries possible is:									
																												
					$.slatwall.getImageGalleryArray( array resizedSizes )										
																												
					This is a very unique method to give you all the data you need to create an image gallery	
					with whatever sizes.  The ImageGalleryArray will take whatever sizes you pass in, and pass	
					back the details and resized image paths for all of the skus default images as well as any	
					alternative images that were assigned to the product.										
																												
					For example, if you wanted to get 2 sizes back 100x100 and 500x500 so that you could		
					display thumbnails ect.  You would just do:													
																												
					$.slatwall.getImageGalleryArray( [ {width=100, height=100}, {width=500, height=500} ] )		
																												
																												
					By default if you don't pass in your own resizing array, it will just ask for the 3 sizes	
					of Small, Medium, and Large which will get the actually sizes from the product settings.	
					The logic it runs by default is the same as if you did this:								
																												
					$.slatwall.getImageGalleryArray( [ {size='small'},{size='medium'},{size='large'} ] )		
																												
																												
					Basically every structure in the array, will just call the getResizedImagePath() method		
					so you can pass in whatever resizing and cropping arguments you like based on the specs		
					that you read more about here:																
																												
					http://docs.getslatwall.com/reference/product-images-and-cropping/							
																												
				--->
				<cfloop array="#local.galleryDetails#" index="local.image">
					
					<!---[ DEVELOPER NOTES ]																		
																													
						Now that we are inside of the loop of images being returned, you have access to the			
						following detials insilde of the local.image struct that came back in the array				
																													
					--->
				</cfloop>
				
			</div>
		</div>
		<!--- End: Image Gallery Example --->
	</div>
</cfoutput>

<!--- This footer should be replaced with the footer of your site --->
<cfinclude template="_slatwall-footer.cfm" />