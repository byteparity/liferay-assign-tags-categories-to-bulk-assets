package com.byteparity.common.component.portlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.portlet.PortletException;
import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;
import javax.servlet.http.HttpServletResponse;

import org.osgi.service.component.annotations.Component;

import com.byteparity.common.component.constants.AssignTagCategoryToAssetsPortletKeys;
import com.liferay.asset.entry.rel.service.AssetEntryAssetCategoryRelLocalServiceUtil;
import com.liferay.asset.kernel.model.AssetEntry;
import com.liferay.asset.kernel.model.AssetTag;
import com.liferay.asset.kernel.service.AssetEntryLocalServiceUtil;
import com.liferay.asset.kernel.service.AssetTagLocalServiceUtil;
import com.liferay.blogs.kernel.model.BlogsEntry;
import com.liferay.blogs.kernel.service.BlogsEntryLocalServiceUtil;
import com.liferay.bookmarks.model.BookmarksEntry;
import com.liferay.document.library.kernel.model.DLFileEntry;
import com.liferay.journal.model.JournalArticle;
import com.liferay.journal.service.JournalArticleLocalServiceUtil;
import com.liferay.message.boards.kernel.model.MBMessage;
import com.liferay.message.boards.kernel.model.MBThread;
import com.liferay.message.boards.kernel.service.MBThreadLocalServiceUtil;
import com.liferay.portal.kernel.dao.orm.DynamicQuery;
import com.liferay.portal.kernel.dao.orm.PropertyFactoryUtil;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.json.JSONObject;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCResourceCommand;
import com.liferay.portal.kernel.service.ServiceContext;
import com.liferay.portal.kernel.service.ServiceContextFactory;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.Validator;
import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.wiki.model.WikiPage;
import com.liferay.wiki.service.WikiPageLocalServiceUtil;

@Component(
		property = {
		"javax.portlet.name=" + AssignTagCategoryToAssetsPortletKeys.AssignTagCategoryToAssets,
		 "mvc.command.name=/assignEntries"
	},
	service = MVCResourceCommand.class
)
public class AssignTagAndCategoriesMVCResourceCommand implements MVCResourceCommand {

	private static final Log _log = LogFactoryUtil.getLog(AssignTagAndCategoriesMVCResourceCommand.class);

	/**
	 * Assign AssetTag and AssetCategory to different types of Assets
	 */
	@Override
	public boolean serveResource(ResourceRequest resourceRequest, ResourceResponse resourceResponse)
			throws PortletException {

		ThemeDisplay themeDisplay = (ThemeDisplay) resourceRequest.getAttribute(WebKeys.THEME_DISPLAY);
		String categoryIds = ParamUtil.getString(resourceRequest, "assetCategoryIds");
		String assetTagNames = ParamUtil.getString(resourceRequest, "assetTagNames");
		String assetIds = ParamUtil.getString(resourceRequest, "assetIds");
		String assetType = ParamUtil.getString(resourceRequest, "assetType");
		String nodeId = ParamUtil.getString(resourceRequest, "nodeId");
		
		JSONObject json = JSONFactoryUtil.createJSONObject();
		List<AssetEntry> assetEntries = new ArrayList<AssetEntry>();

		if (assetType.equals(JournalArticle.class.getName())) {
			assetEntries = getAssetEntriesByJournalArticle(assetIds, themeDisplay);
		}else if (assetType.equals(BlogsEntry.class.getName()) || assetType.equals("com.liferay.blogs.model.BlogsEntry")) {
			assetEntries = getAssetEntriesByBlogsEntry(assetIds, themeDisplay);
		}else if (assetType.equals(WikiPage.class.getName())) {
			if(Validator.isNotNull(nodeId)) {
				assetEntries = getAssetEntriesByWikiPages(assetIds, themeDisplay,nodeId);
			}			
		}else if (assetType.equals(BookmarksEntry.class.getName())) {
			assetEntries = getAssetEntriesByBookmarksEntry(assetIds, themeDisplay);	
		}else if (assetType.equals(MBThread.class.getName()) || assetType.equals("com.liferay.message.boards.model.MBThread")) {
			assetEntries = getAssetEntriesByMBThread(assetIds, themeDisplay);		
		}else if (assetType.equals(DLFileEntry.class.getName())) {
			assetEntries = getAssetEntriesByDLfileEntry(assetIds, themeDisplay);	
		}
		
		if(assetEntries.size() > 0) {
			try {
				json = assignTagCategory(assetEntries, categoryIds, assetTagNames, themeDisplay, resourceRequest);
				resourceResponse.setContentType("application/json");
			     resourceResponse.setProperty(ResourceResponse.HTTP_STATUS_CODE, Integer.toString(HttpServletResponse.SC_OK));
				resourceResponse.getWriter().println(json);
				return true;
			} catch (IOException e) {
				_log.error(e.getMessage());
			}
		}
		
		return false;
	}

	/**
	 * Return JSON Response
	 * 
	 * @param assetEntries
	 * @param categoryIds
	 * @param assetTagNames
	 * @param assetIds
	 * @param themeDisplay
	 * @param resourceRequest
	 * @return  response json Object
	 */
	public JSONObject assignTagCategory(List<AssetEntry> assetEntries, String categoryIds, String assetTagNames,
			 ThemeDisplay themeDisplay, ResourceRequest resourceRequest) {

		JSONObject json = JSONFactoryUtil.createJSONObject();
		if (Validator.isNotNull(categoryIds) && (!categoryIds.equals(""))) {
			String[] categoryIdsArray = categoryIds.split(",");
			for(AssetEntry assetEntry : assetEntries){
				for(int i=0;i<categoryIdsArray.length; i++){
					AssetEntryAssetCategoryRelLocalServiceUtil.addAssetEntryAssetCategoryRel(assetEntry.getEntryId(), Long.valueOf(categoryIdsArray[i]), 0);
				}
			}
	
			//AssetCategoryLocalServiceUtil.addAssetEntryAssetCategories(36336, new long [] {36310});
			//AssetEntryLocalServiceUtil.addAssetCategoryAssetEntry(36310, AssetEntryLocalServiceUtil.getAssetEntry(36336));
			//AssetCategoryLocalServiceUtil.addAssetEntryAssetCategories(36336, new long [] {36310});
			//AssetEntryLocalServiceUtil.addAssetCategoryAssetEntries(36310, assetEntries);
			
		}

		if (Validator.isNotNull(assetTagNames) && (!assetTagNames.equals(""))) {
			String[] assetTagNamesArray = assetTagNames.split(",");

			for (String assetTagName : assetTagNamesArray) {
				long tagId = 0;
				AssetTag tag = null;
				ServiceContext serviceContext;
				try {
					serviceContext = ServiceContextFactory.getInstance(AssetTag.class.getName(), resourceRequest);
					serviceContext.setScopeGroupId(themeDisplay.getScopeGroupId());

					tag = AssetTagLocalServiceUtil.fetchTag(themeDisplay.getScopeGroupId(), assetTagName);

					if (Validator.isNotNull(tag)) {
						tagId = tag.getTagId();

					} else {
						tagId = AssetTagLocalServiceUtil.addTag(themeDisplay.getUserId(),
								themeDisplay.getScopeGroupId(), assetTagName, serviceContext).getTagId();
					}
					AssetEntryLocalServiceUtil.addAssetTagAssetEntries(tagId, assetEntries);
					json.put("success", "Assing Web content Sucessfully");
				} catch (PortalException e1) {
					json.put("error", "Failed to assign Web Content");
					_log.error(e1.getMessage());
				}
			}
		}
		return json;
	}

	/**
	 * 	Get AssetEntries For Journal Article
	 * 
	 * @param assetIds journal article Ids
	 * @param themeDisplay  {@link ThemeDisplay}
	 * @return List of AssetEntry
	 */
	public List<AssetEntry> getAssetEntriesByJournalArticle(String assetIds, ThemeDisplay themeDisplay) {
		List<AssetEntry> assetEntries = new ArrayList<AssetEntry>();
		if (Validator.isNotNull(assetIds) && (!assetIds.equals(""))) {
			String[] articleIdsArray = assetIds.split(",");
			for (String articleId : articleIdsArray) {
				try {
					JournalArticle article = JournalArticleLocalServiceUtil.getArticle(themeDisplay.getScopeGroupId(), articleId);
					long resourcePrimKey = article.getResourcePrimKey();
					AssetEntry entry = AssetEntryLocalServiceUtil.getEntry(JournalArticle.class.getName(),resourcePrimKey);
					assetEntries.add(entry);
				} catch (PortalException e) {
					e.printStackTrace();
					_log.error(e.getMessage());
				}
			}
		}
		return assetEntries;
	}

	
	/**
	 * Get AssetEntries for BlogsEntry 
	 * @param assetIds BlogsEntry Ids
	 * @param themeDisplay {@link ThemeDisplay}
	 * @return List of AssetEntry
	 */
	public List<AssetEntry> getAssetEntriesByBlogsEntry(String assetIds, ThemeDisplay themeDisplay) {

		List<AssetEntry> assetEntries = new ArrayList<AssetEntry>();
		if (Validator.isNotNull(assetIds) && (!assetIds.equals(""))) {
			String[] blogsIdsArray = assetIds.split(",");
			for (String entryId : blogsIdsArray) {
				BlogsEntry blogsEntry = null;
				try {
					blogsEntry = BlogsEntryLocalServiceUtil.getBlogsEntry(Long.valueOf(entryId));
					long resourcePrimKey = blogsEntry.getEntryId();
					AssetEntry assetentry = AssetEntryLocalServiceUtil.getEntry("com.liferay.blogs.model.BlogsEntry",
							resourcePrimKey);
					assetEntries.add(assetentry);
				} catch (PortalException e) {
					_log.error(e.getMessage());
				}
			}
		}
		return assetEntries;
	}
	
	/**
	 * Get AssetEntries for WikiPages
	 * @param assetIds Wikipage's Titles
	 * @param themeDisplay 
	 * @param nodeId WikiNode Id
	 * @return List of AssetEntry
	 */
	public List<AssetEntry> getAssetEntriesByWikiPages(String assetIds, ThemeDisplay themeDisplay,String nodeId) {

		List<AssetEntry> assetEntries = new ArrayList<AssetEntry>();
		if (Validator.isNotNull(assetIds) && (!assetIds.equals(""))) {
			String[] pageTitlesArray = assetIds.split(",");
			for (String pageTitle : pageTitlesArray) {
			WikiPage wikiPage = null;
				try {
					wikiPage = WikiPageLocalServiceUtil.fetchPage(Long.valueOf(nodeId), pageTitle);
					long resourcePrimKey = wikiPage.getResourcePrimKey();
					AssetEntry assetentry = AssetEntryLocalServiceUtil.getEntry(WikiPage.class.getName(),
							resourcePrimKey);
					assetEntries.add(assetentry);
				} catch (PortalException e) {
					_log.error(e.getMessage());
				}
			}
		}
		return assetEntries;
	}
	/**
	 * Get AssetEntrie for BookmarksEntry 
	 * @param assetIds	BookmarksEntry Id
	 * @param themeDisplay
	 * @return List of AssetEntry
	 */
	public List<AssetEntry> getAssetEntriesByBookmarksEntry(String assetIds, ThemeDisplay themeDisplay) {

		List<AssetEntry> assetEntries = new ArrayList<AssetEntry>();

		if (Validator.isNotNull(assetIds) && (!assetIds.equals(""))) {
			String[] bookmarksIdsArray = assetIds.split(",");
			for (String entryId : bookmarksIdsArray) {
				AssetEntry assetEntry = getAssetEntry(entryId);
				if (assetEntry != null) 
						if (assetEntry.getClassName().equals(BookmarksEntry.class.getName())) {
							assetEntries.add(assetEntry);
						}
					
				}
			}
		return assetEntries;
	}
	
	/**
	 * Get AssetEntries for Message Board Thread
	 * @param assetIds	MBThread Ids
	 * @param themeDisplay
	 * @return List of AssetEntry 
	 */
	public List<AssetEntry> getAssetEntriesByMBThread(String assetIds, ThemeDisplay themeDisplay) {

		List<AssetEntry> assetEntries = new ArrayList<AssetEntry>();
		if (Validator.isNotNull(assetIds) && (!assetIds.equals(""))) {
			String[] threadIdsArray = assetIds.split(",");
			for (String threadId : threadIdsArray) {
				AssetEntry assetEntry = getAssetEntry(threadId);
				if(assetEntry != null) {
					if(assetEntry.getClassName().equals(MBThread.class.getName()) || assetEntry.getClassName().equals("com.liferay.message.boards.model.MBThread")) {
						MBThread mbthread = null;
						try {
							mbthread = MBThreadLocalServiceUtil.getMBThread(Long.valueOf(threadId));
							AssetEntry entry = getAssetEntry(String.valueOf(mbthread.getRootMessageId()));
							if(entry.getClassName().equals(MBMessage.class.getName()) || entry.getClassName().equals("com.liferay.message.boards.model.MBMessage")) {
								assetEntries.add(entry);
							}
						} catch (NumberFormatException | PortalException e) {
							_log.error(e.getMessage());
						}
					}
				}	
			}
		}
		return assetEntries;
	}
	
	
	/**
	 * Get AssetEntries for DLFileEntry
	 * @param assetIds DLFileEntry Id
	 * @param themeDisplay
	 * @return List of AssetEntry
	 */
	public List<AssetEntry> getAssetEntriesByDLfileEntry(String assetIds, ThemeDisplay themeDisplay) {

		List<AssetEntry> assetEntries = new ArrayList<AssetEntry>();
		if (Validator.isNotNull(assetIds) && (!assetIds.equals(""))) {
			String[] dlFileEntryIdsArray = assetIds.split(",");
			for (String dlFileEntryId : dlFileEntryIdsArray) {
				AssetEntry assetEntry = getAssetEntry(dlFileEntryId);
				if(assetEntry != null) {
					if(assetEntry.getClassName().equals(DLFileEntry.class.getName())) {
						assetEntries.add(assetEntry);
					}
				}
			}
		}
		return assetEntries;
	}
	
	/**
	 * Get AssetEntry by ID 
	 * @param id id of any Asset Type
	 * @return  Object of AssetEntry
	 */
	public AssetEntry getAssetEntry(String id) {
	
		AssetEntry assetentry = null;
		DynamicQuery query = AssetEntryLocalServiceUtil.dynamicQuery();
		query.add(PropertyFactoryUtil.forName("classPK").eq(Long.valueOf(id)));
		List<AssetEntry> entries = AssetEntryLocalServiceUtil.dynamicQuery(query);
		if(entries.size() > 0) {
			assetentry = entries.get(0);
		}
		return assetentry;
	}
}
