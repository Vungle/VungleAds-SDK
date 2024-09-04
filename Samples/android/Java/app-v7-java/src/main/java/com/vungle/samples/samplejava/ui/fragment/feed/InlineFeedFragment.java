package com.vungle.samples.samplejava.ui.fragment.feed;

import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import com.vungle.ads.BannerAdListener;
import com.vungle.ads.BaseAd;
import com.vungle.ads.VungleAdSize;
import com.vungle.ads.VungleBannerView;
import com.vungle.ads.VungleError;
import com.vungle.samples.samplejava.R;
import java.util.ArrayList;

public class InlineFeedFragment extends Fragment {

  private static final String TAG = "InlineFeedSample";

  // A inline ad is placed in every 16th position in the RecyclerView.
  static final int ITEMS_PER_AD = 16;

  private String placementId;
  private String feedOrientation;

  // List of inline ads and sample data that populate the RecyclerView.
  private final ArrayList<Object> recyclerViewItems = new ArrayList<>();

  @Nullable
  @Override
  public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container,
      @Nullable Bundle savedInstanceState) {
    assert getArguments() != null;
    placementId = getArguments().getString( "placement_id" );
    feedOrientation = getArguments().getString( "orientation" );
    return inflater.inflate( R.layout.fragment_inline_feed, container, false );
  }

  @Override
  public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
    super.onViewCreated( view, savedInstanceState );
    RecyclerView recyclerView = view.findViewById( R.id.recycler_view );
    recyclerView.setHasFixedSize( true );
    RecyclerView.LayoutManager layoutManager;
    if ("horizontal".equals( feedOrientation )) {
      layoutManager = new LinearLayoutManager(
          requireContext(),
          LinearLayoutManager.HORIZONTAL,
          false
      );
    } else {
      layoutManager = new LinearLayoutManager( requireContext() );
    }

    recyclerView.setLayoutManager( layoutManager );

    // Update the RecyclerView item's list with sample items and inline ads.
    ArrayList<CommonSampleData> demoDatas = CommonSampleData.createDemoDataList( requireContext() );
    recyclerViewItems.addAll( demoDatas );
    addInlineAds();
    loadInlineAds();

    // Specify an adapter.
    InlineAdFeedAdapter adapter = new InlineAdFeedAdapter( recyclerViewItems, feedOrientation );

    recyclerView.setAdapter( adapter );
  }

  /**
   * Adds inline ads to the items list.
   */
  private void addInlineAds() {
    VungleAdSize vunAdSize = VungleAdSize.getAdSizeWithWidthAndHeight( 300, 200 );

    // Loop through the items array and place a new inline ad in every ith position in
    // the items List.
    var i = 0;
    while (i <= recyclerViewItems.size()) {
      VungleBannerView adView = new VungleBannerView( requireContext(), placementId, vunAdSize );
      recyclerViewItems.add( i, adView );
      i += ITEMS_PER_AD;
    }
  }

  /**
   * Sets up and loads the inline ads.
   */
  private void loadInlineAds() {
    // Load the first ad in the items list (subsequent ads will be loaded automatically
    // in sequence).
    loadInlineAd( 0 );
  }

  /**
   * Loads the inline ads in the items list.
   */
  private void loadInlineAd(int index) {
    if (index >= recyclerViewItems.size()) {
      return;
    }

    if (!(recyclerViewItems.get( index ) instanceof VungleBannerView)) {
      throw new ClassCastException( "Expected item at index $index to be a inline ad" );
    }
    VungleBannerView item = (VungleBannerView) recyclerViewItems.get( index );

    item.setAdListener( new BannerAdListener() {

      @Override
      public void onAdLoaded(@NonNull BaseAd baseAd) {
        Log.d( TAG, "onAdLoaded(): " + baseAd );

        // The previous ad loaded successfully, call this method again to
        // load the next ad in the items list.
        loadInlineAd( index + ITEMS_PER_AD );
      }

      @Override
      public void onAdFailedToPlay(@NonNull BaseAd baseAd, @NonNull VungleError vungleError) {
        Log.d( TAG, "onAdFailedToPlay(): " + baseAd + " error:" + vungleError );
      }

      @Override
      public void onAdFailedToLoad(@NonNull BaseAd baseAd, @NonNull VungleError vungleError) {
        Log.d( TAG, "onAdFailedToLoad(): " + baseAd + " error:" + vungleError );
        loadInlineAd( index + ITEMS_PER_AD );
      }

      @Override
      public void onAdLeftApplication(@NonNull BaseAd baseAd) {
        Log.d( TAG, "onAdLeftApplication(): " + baseAd );
      }

      @Override
      public void onAdEnd(@NonNull BaseAd baseAd) {
        Log.d( TAG, "onAdEnd(): " + baseAd );
      }

      @Override
      public void onAdImpression(@NonNull BaseAd baseAd) {
        Log.d( TAG, "onAdImpression(): " + baseAd );
      }

      @Override
      public void onAdStart(@NonNull BaseAd baseAd) {
        Log.d( TAG, "onAdStart(): " + baseAd );
      }

      @Override
      public void onAdClicked(@NonNull BaseAd baseAd) {
        Log.d( TAG, "onAdClicked(): " + baseAd );
      }

    } );

    // Load the inline ad.
    item.load( null );
  }

  @Override
  public void onDestroyView() {
    for (Object obj : recyclerViewItems) {
      if (obj instanceof VungleBannerView) {
        VungleBannerView item = (VungleBannerView) obj;
        item.finishAd();
        item.setAdListener( null );
      }
    }
    super.onDestroyView();
  }

}
