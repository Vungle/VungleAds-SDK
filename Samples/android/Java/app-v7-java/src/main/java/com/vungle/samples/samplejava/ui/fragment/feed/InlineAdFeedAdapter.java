package com.vungle.samples.samplejava.ui.fragment.feed;

import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.TextView;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import androidx.recyclerview.widget.RecyclerView.ViewHolder;
import com.vungle.ads.VungleBannerView;
import com.vungle.samples.samplejava.R;
import java.util.List;

public class InlineAdFeedAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder> {

  // A sample item view type.
  private static final int DEMO_ITEM_VIEW_TYPE = 0;
  // The inline ad view type.
  private static final int INLINE_AD_VIEW_TYPE = 1;

  private final List<Object> recyclerViewItems;
  private final String orientation;
  private final int orientationLayoutResId;

  public InlineAdFeedAdapter(List<Object> recyclerViewItems, String orientation) {
    this.recyclerViewItems = recyclerViewItems;
    this.orientation = orientation;
    orientationLayoutResId =
        "horizontal".equals( orientation ) ? R.layout.common_sample_data_item_horizontal
            : R.layout.common_sample_data_item;
  }

  @NonNull
  @Override
  public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
    if (viewType == INLINE_AD_VIEW_TYPE) {
      View view = View.inflate( parent.getContext(), R.layout.feed_inline_ad_container, null );
      return new AdViewHolder( view );
    } else {
      View view = View.inflate( parent.getContext(), orientationLayoutResId, null );
      return new MenuItemViewHolder( view );
    }
  }

  @Override
  public void onBindViewHolder(@NonNull ViewHolder holder, int position) {
    switch (getItemViewType( position )) {
      case DEMO_ITEM_VIEW_TYPE: {
        // Bind the sample item view holder.
        MenuItemViewHolder menuItemHolder = (MenuItemViewHolder) holder;
        // Bind the sample item data to the view holder.
        CommonSampleData menuItem = (CommonSampleData) recyclerViewItems.get( position );

        // Add the menu item details to the menu item view.
        menuItemHolder.menuItemName.setText( menuItem.getName() );
        menuItemHolder.menuItemPrice.setText( menuItem.getMenuItemPrice() );
        menuItemHolder.menuItemCategory.setText( menuItem.getMenuItemCategory() );
        menuItemHolder.menuItemDescription.setText( menuItem.getMenuItemDescription() );
      }
      break;
      case INLINE_AD_VIEW_TYPE: {
        // Bind the inline ad view holder.
        AdViewHolder adViewHolder = (AdViewHolder) holder;
        // Bind the inline ad to the view holder.
        VungleBannerView inlineAdView = (VungleBannerView) recyclerViewItems.get( position );
        ViewGroup adCardView = (ViewGroup) adViewHolder.itemView;
        // The AdViewHolder recycled by the RecyclerView may be a different
        // instance than the one used previously for this position. Clear the
        // AdViewHolder of any subviews in case it has a different
        // AdView associated with it, and make sure the AdView for this position doesn't
        // already have a parent of a different recycled AdViewHolder.
        if (adCardView.getChildCount() > 0) {
          adCardView.removeAllViews();
        }
        if (inlineAdView.getParent() != null) {
          ((ViewGroup) inlineAdView.getParent()).removeView( inlineAdView );
        }

        // Add the inline ad to the ad view.
        ViewGroup.LayoutParams param;
        if ("horizontal".equals( orientation )) {
          param = new FrameLayout.LayoutParams(
              FrameLayout.LayoutParams.MATCH_PARENT,
              FrameLayout.LayoutParams.MATCH_PARENT,
              Gravity.CENTER
          );
        } else {
          param = new FrameLayout.LayoutParams(
              FrameLayout.LayoutParams.MATCH_PARENT,
              FrameLayout.LayoutParams.WRAP_CONTENT,
              Gravity.CENTER
          );
        }

        adCardView.addView( inlineAdView, param );
      }
      break;
    }
  }

  @Override
  public int getItemViewType(int position) {
    if (position % InlineFeedFragment.ITEMS_PER_AD == 0) {
      return INLINE_AD_VIEW_TYPE;
    } else {
      return DEMO_ITEM_VIEW_TYPE;
    }
  }

  @Override
  public int getItemCount() {
    return recyclerViewItems.size();
  }

  private static class MenuItemViewHolder extends RecyclerView.ViewHolder {

    private final TextView menuItemName;
    private final TextView menuItemDescription;
    private final TextView menuItemPrice;
    private final TextView menuItemCategory;

    public MenuItemViewHolder(@NonNull View itemView) {
      super( itemView );
      menuItemName = itemView.findViewById( R.id.menu_item_name );
      menuItemPrice = itemView.findViewById( R.id.menu_item_price );
      menuItemCategory = itemView.findViewById( R.id.menu_item_category );
      menuItemDescription = itemView.findViewById( R.id.menu_item_description );
    }
  }

  private static class AdViewHolder extends RecyclerView.ViewHolder {

    public AdViewHolder(@NonNull View itemView) {
      super( itemView );
    }
  }

}
