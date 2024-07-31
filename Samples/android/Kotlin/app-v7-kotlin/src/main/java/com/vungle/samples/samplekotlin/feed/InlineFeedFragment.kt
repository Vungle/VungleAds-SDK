package com.vungle.samples.samplekotlin.feed

import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.vungle.ads.BannerAdListener
import com.vungle.ads.BaseAd
import com.vungle.ads.VungleAdSize
import com.vungle.ads.VungleBannerView
import com.vungle.ads.VungleError
import com.vungle.samples.samplekotlin.R
import com.vungle.samples.samplekotlin.databinding.FragmentInlineFeedBinding

class InlineFeedFragment : Fragment(R.layout.fragment_inline_feed) {

    companion object {
        private const val TAG = "InlineFeedSample"

        // A inline ad is placed in every 16th position in the RecyclerView.
        const val ITEMS_PER_AD = 16

    }

    private var _binding: FragmentInlineFeedBinding? = null
    val binding get() = _binding!!
    private lateinit var placementId: String
    private lateinit var feedOrientation: String

    // List of inline ads and sample data that populate the RecyclerView.
    private val recyclerViewItems: MutableList<Any> = ArrayList()

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        _binding = FragmentInlineFeedBinding.inflate(inflater, container, false)
        placementId = arguments?.getString("placement_id").toString()
        feedOrientation = arguments?.getString("orientation").toString()

        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        configureUi()
    }

    private fun configureUi() {
        binding.apply {
            recyclerView.setHasFixedSize(true)
            val layoutManager: RecyclerView.LayoutManager = when (feedOrientation) {
                "vertical" -> LinearLayoutManager(requireContext())
                "horizontal" -> LinearLayoutManager(
                    requireContext(),
                    LinearLayoutManager.HORIZONTAL,
                    false
                )

                else -> LinearLayoutManager(requireContext())
            }
            recyclerView.layoutManager = layoutManager

            // Update the RecyclerView item's list with sample items and inline ads.
            val demoDatas = CommonSampleData.createDemoDataList(requireContext())
            recyclerViewItems.addAll(demoDatas)
            addInlineAds()
            loadInlineAds()

            // Specify an adapter.
            val adapter = InlineAdFeedAdapter(recyclerViewItems, feedOrientation)

            recyclerView.adapter = adapter
        }
    }

    /**
     * Adds inline ads to the items list.
     */
    private fun addInlineAds() {
        val vunAdSize = VungleAdSize.getAdSizeWithWidthAndHeight(300, 200)

        // Loop through the items array and place a new inline ad in every ith position in
        // the items List.
        var i = 0
        while (i <= recyclerViewItems.size) {
            val adView = VungleBannerView(requireContext(), placementId, vunAdSize)
            recyclerViewItems.add(i, adView)
            i += ITEMS_PER_AD
        }
    }

    /**
     * Sets up and loads the inline ads.
     */
    private fun loadInlineAds() {
        // Load the first ad in the items list (subsequent ads will be loaded automatically
        // in sequence).
        loadInlineAd(0)
    }

    /**
     * Loads the inline ads in the items list.
     */
    private fun loadInlineAd(index: Int) {
        if (index >= recyclerViewItems.size) {
            return
        }
        val item = recyclerViewItems[index] as? VungleBannerView
            ?: throw ClassCastException("Expected item at index $index to be a inline ad")
        item.adListener = object : BannerAdListener {
            override fun onAdLoaded(baseAd: BaseAd) {
                Log.d(TAG, "onAdLoaded(): $baseAd")

                // The previous ad loaded successfully, call this method again to
                // load the next ad in the items list.
                loadInlineAd(index + ITEMS_PER_AD)
            }

            override fun onAdStart(baseAd: BaseAd) {
                Log.d(TAG, "onAdStart(): $baseAd")
            }

            override fun onAdImpression(baseAd: BaseAd) {
                Log.d(TAG, "onAdImpression(): $baseAd")
            }

            override fun onAdEnd(baseAd: BaseAd) {
                Log.d(TAG, "onAdEnd(): $baseAd")
            }

            override fun onAdClicked(baseAd: BaseAd) {
                Log.d(TAG, "onAdClicked(): $baseAd")
            }

            override fun onAdLeftApplication(baseAd: BaseAd) {
                Log.d(TAG, "onAdLeftApplication(): $baseAd")
            }

            override fun onAdFailedToLoad(baseAd: BaseAd, adError: VungleError) {
                // The previous ad failed to load. Call this method again to load
                // the next ad in the items list.
                Log.d(TAG, "onAdFailedToLoad(): $baseAd $adError")
                loadInlineAd(index + ITEMS_PER_AD)
            }

            override fun onAdFailedToPlay(baseAd: BaseAd, adError: VungleError) {
                Log.d(TAG, "onAdFailedToPlay(): $baseAd $adError")
            }
        }

        // Load the inline ad.
        item.load(null)
    }

    override fun onDestroyView() {
        for (item in recyclerViewItems) {
            if (item is VungleBannerView) {
                item.finishAd()
                item.adListener = null
            }
        }
        super.onDestroyView()
    }


}
