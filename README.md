# Liferay Bulk of Tags Or Categories

If Liferay Administrator want to add tags or categories to any Asset, then admin has to do it by editing that individual Asset. For example if Admin want to assign "liferay-dxp" tag to the web content having text "liferay" in it. In such case admin has to first search web contents having text "liferay" and then assign "liferay-dxp" tag to each web content by editing each one manually. With the help of this component admin can assign tags (categories) to multiple web contents without opening individual web content.  

This component will add given feature to Web Content, Document, Bookmark, Wiki Pages, Message Boards and Blogs.

## Environment

* Liferay 7 - GA5 +,Liferay 7.1 - GA1 +, Liferay DXP
* MySQL 5.6 +

## How to use

1. Download, build and install portlets and fragments on your server.
2. Check module status in liferay tomcat server using console log OR using gogo shell.
3. Create Blogs, Web Content, Bookmarks, Wiki Pages, Message Boards and Document and media files
4. Create Categories and Tags
5. Go to your Site -> Content -> Web Content 

    ![ScreenShot](https://user-images.githubusercontent.com/24852574/39166549-e3215356-47a7-11e8-9b66-14953d207750.png)
    
6. Upon selecting multiple Web Contents, you will find Assign Tags or Categories icon on top right corner of page.

    ![ScreenShot](https://user-images.githubusercontent.com/24852574/39166726-da35c686-47a8-11e8-841c-db651b7d4bec.png)

7. Click on that icon and it will show below popup window

    ![ScreenShot](https://user-images.githubusercontent.com/24852574/39166600-1eb5d86a-47a8-11e8-9dbf-5cd6d744c2e0.png)

8. Select Categories and Tags you want to assign and then click on submit, you see success message if Tags or Category assigned  Successfully otherwise it shows error message.

    ![ScreenShot](https://user-images.githubusercontent.com/24852574/39166614-348c3db4-47a8-11e8-9f21-6a6ce24838b7.png)

9. You will find similar behavior while assigning tags or categories to Document and Media, Wiki Pages, Blogs, Bookmarks, Message Boards.


## Support
   Please feel free to contact us on hello@byteparity.com for any issue/suggestions.
