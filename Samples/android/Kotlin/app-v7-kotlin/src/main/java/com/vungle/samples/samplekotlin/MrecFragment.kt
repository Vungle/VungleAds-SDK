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

class MrecFragment : AdExperienceFragment(), BannerAdListener {

  private var mrecAd: VungleBannerView? = null

  override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
    super.onViewCreated(view, savedInstanceState)

    configureUi()
  }

  override fun loadAd() {
    super.loadAd()
    mrecAd = VungleBannerView(requireContext(), placementId, VungleAdSize.MREC).apply {
      adListener = this@MrecFragment
      load()
    }.also {
      val params = FrameLayout.LayoutParams(
        FrameLayout.LayoutParams.WRAP_CONTENT,
        FrameLayout.LayoutParams.WRAP_CONTENT,
        Gravity.CENTER_HORIZONTAL
      )
      binding.adContainer.addView(it, params)
    }
  }

  override fun destroyAd() {
    super.destroyAd()
    mrecAd?.finishAd()
    mrecAd?.adListener = null
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
//      txtAdHeight.text = mrecAd?.adConfig?.adSize?.height.toString()
//      txtAdWidth.text = mrecAd?.adConfig?.adSize?.width.toString()
    }
  }

  override fun onDestroyView() {
    super.onDestroyView()
    mrecAd = null
  }
}