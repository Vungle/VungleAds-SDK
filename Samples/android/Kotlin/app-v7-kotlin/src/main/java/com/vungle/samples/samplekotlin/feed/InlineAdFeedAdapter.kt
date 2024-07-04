package com.vungle.samples.samplekotlin.feed

import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.vungle.ads.VungleBannerView
import com.vungle.samples.samplekotlin.R

class InlineAdFeedAdapter(
    private val recyclerViewItems: List<Any>,
    private val orientation: String
) : RecyclerView.Adapter<RecyclerView.ViewHolder>() {

    private val orientationLayoutResId = when (orientation) {
        "vertical" -> R.layout.common_sample_data_item
        "horizontal" -> R.layout.common_sample_data_item_horizontal
        else -> R.layout.common_sample_data_item
    }
    /**
     * The [MenuItemViewHolder] class. Provides a reference to each view in the menu item view.
     */
    inner class MenuItemViewHolder internal constructor(view: View) :
        RecyclerView.ViewHolder(view) {
        val menuItemName: TextView
        val menuItemDescription: TextView
        val menuItemPrice: TextView
        val menuItemCategory: TextView

        init {
            menuItemName = view.findViewById(R.id.menu_item_name)
            menuItemPrice = view.findViewById(R.id.menu_item_price)
            menuItemCategory = view.findViewById(R.id.menu_item_category)
            menuItemDescription = view.findViewById(R.id.menu_item_description)
        }
    }

    /**
     * The [AdViewHolder] class.
     */
    inner class AdViewHolder internal constructor(view: View?) : RecyclerView.ViewHolder(
        view!!
    )

    override fun getItemCount(): Int {
        return recyclerViewItems.size
    }

    /**
     * Determines the view type for the given position.
     */
    override fun getItemViewType(position: Int): Int {
        return if (position % InlineFeedFragment.ITEMS_PER_AD == 0) INLINE_AD_VIEW_TYPE else DEMO_ITEM_VIEW_TYPE
    }

    /**
     * Creates a new view for a menu item view or a inline ad view based on the viewType. This method
     * is invoked by the layout manager.
     */
    override fun onCreateViewHolder(viewGroup: ViewGroup, viewType: Int): RecyclerView.ViewHolder {
        return when (viewType) {
            INLINE_AD_VIEW_TYPE -> {
                val adLayoutView = LayoutInflater.from(
                    viewGroup.context
                ).inflate(
                    R.layout.feed_inline_ad_container,
                    viewGroup, false
                )
                AdViewHolder(adLayoutView)
            }
            else -> {
                val menuItemLayoutView = LayoutInflater.from(viewGroup.context).inflate(
                    orientationLayoutResId, viewGroup, false
                )
                MenuItemViewHolder(menuItemLayoutView)
            }
        }
    }

    /**
     * Replaces the content in the views that make up the menu item view and the ad view. This
     * method is invoked by the layout manager.
     */
    override fun onBindViewHolder(holder: RecyclerView.ViewHolder, position: Int) {
        when (getItemViewType(position)) {
            DEMO_ITEM_VIEW_TYPE -> {
                val menuItemHolder = holder as MenuItemViewHolder
                val menuItem = recyclerViewItems[position] as CommonSampleData

                // Add the menu item details to the menu item view.
                menuItemHolder.menuItemName.text = menuItem.name
                menuItemHolder.menuItemPrice.text = menuItem.price
                menuItemHolder.menuItemCategory.text = menuItem.category
                menuItemHolder.menuItemDescription.text = menuItem.description
            }
            INLINE_AD_VIEW_TYPE -> {
                val adHolder = holder as AdViewHolder
                val inlineAdView = recyclerViewItems[position] as VungleBannerView
                val adCardView = adHolder.itemView as ViewGroup
                // The AdViewHolder recycled by the RecyclerView may be a different
                // instance than the one used previously for this position. Clear the
                // AdViewHolder of any subviews in case it has a different
                // AdView associated with it, and make sure the AdView for this position doesn't
                // already have a parent of a different recycled AdViewHolder.
                if (adCardView.childCount > 0) {
                    adCardView.removeAllViews()
                }
                if (inlineAdView.parent != null) {
                    (inlineAdView.parent as ViewGroup).removeView(inlineAdView)
                }

                // Add the inline ad to the ad view.
                val param = when (orientation) {
                    "vertical" -> FrameLayout.LayoutParams(
                        FrameLayout.LayoutParams.MATCH_PARENT,
                        FrameLayout.LayoutParams.WRAP_CONTENT
                    )

                    "horizontal" -> FrameLayout.LayoutParams(
                        FrameLayout.LayoutParams.MATCH_PARENT,
                        FrameLayout.LayoutParams.MATCH_PARENT
                    )

                    else -> FrameLayout.LayoutParams(
                        FrameLayout.LayoutParams.MATCH_PARENT,
                        FrameLayout.LayoutParams.WRAP_CONTENT
                    )
                }
                param.gravity = Gravity.CENTER

                adCardView.addView(inlineAdView, param)
            }
        }
    }

    companion object {
        // A sample item view type.
        private const val DEMO_ITEM_VIEW_TYPE = 0

        // The inline ad view type.
        private const val INLINE_AD_VIEW_TYPE = 1
    }
}
