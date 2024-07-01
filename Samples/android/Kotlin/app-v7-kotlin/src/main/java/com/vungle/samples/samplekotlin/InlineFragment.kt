package com.vungle.samples.samplekotlin

import android.os.Bundle
import android.view.Gravity
import android.view.View
import android.widget.FrameLayout
import com.vungle.samples.samplekotlin.ui.AdExperienceFragment
import com.vungle.samples.samplekotlin.utils.extensions.show
import com.vungle.ads.BannerAdListener
import com.vungle.ads.BaseAd
import com.vungle.ads.VungleAdSize
import com.vungle.ads.VungleBannerView
import com.vungle.ads.VungleError

class InlineFragment : AdExperienceFragment(), BannerAdListener {

  private var bannerAd: VungleBannerView? = null

  override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
    super.onViewCreated(view, savedInstanceState)

    configureUi()
  }

  override fun loadAd() {
    super.loadAd()
    val vngSize = VungleAdSize.getAdSizeWithWidthAndHeight(300,200)
    bannerAd = VungleBannerView(requireContext(), placementId, vngSize).apply {
      adListener = this@InlineFragment
      load()
    }.also {
      val params = FrameLayout.LayoutParams(
        FrameLayout.LayoutParams.WRAP_CONTENT,
        FrameLayout.LayoutParams.WRAP_CONTENT,
        Gravity.CENTER
      )
      binding.adContainer.addView(it, params)
    }
  }

  override fun playAd() {
    super.playAd()
  }

  override fun destroyAd() {
    super.destroyAd()
    bannerAd?.finishAd()
    bannerAd?.adListener = null
  }

  override fun onAdLoaded(baseAd: BaseAd) {
    super.onAdLoaded(baseAd)
    bannerDimensionUi()
  }

  override fun onAdStart(baseAd: BaseAd) {
    super.onAdStart(baseAd)
  }

  override fun onAdImpression(baseAd: BaseAd) {
    super.onAdImpression(baseAd)
  }

  override fun onAdEnd(baseAd: BaseAd) {
    super.onAdEnd(baseAd)
  }

  override fun onAdClicked(baseAd: BaseAd) {
    super.onAdClicked(baseAd)
  }

  override fun onAdLeftApplication(baseAd: BaseAd) {
    super.onAdLeftApplication(baseAd)
  }

  override fun onAdFailedToLoad(baseAd: BaseAd, adError: VungleError) {
    super.onAdFailedToLoad(baseAd, adError)
  }

  override fun onAdFailedToPlay(baseAd: BaseAd, adError: VungleError) {
    super.onAdFailedToPlay(baseAd, adError)
  }
  private fun configureUi() {
    binding.apply {
      lbPlacementId.text = placementId
      btnDestroyAd.show()
      groupBanner.show()
    }
  }

  private fun bannerDimensionUi() {
    binding.apply{
//      txtAdHeight.text = bannerAd?.adConfig?.adSize?.height.toString()
//      txtAdWidth.text = bannerAd?.adConfig?.adSize?.width.toString()
    }
  }

  override fun onDestroyView() {
    super.onDestroyView()
    bannerAd = null
  }
}