package com.vungle.samples.samplekotlin

import android.os.Bundle
import android.view.Gravity
import android.view.View
import android.widget.FrameLayout
import com.vungle.samples.samplekotlin.ui.AdExperienceFragment
import com.vungle.samples.samplekotlin.utils.extensions.show
import com.vungle.ads.BannerAdSize
import com.vungle.ads.BannerAd
import com.vungle.ads.BannerAdListener
import com.vungle.ads.BannerView
import com.vungle.ads.BaseAd
import com.vungle.ads.VungleError

class MrecFragment : AdExperienceFragment(), BannerAdListener {

  private var mrecAd: BannerAd? = null

  override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
    super.onViewCreated(view, savedInstanceState)

    configureUi()
  }

  override fun loadAd() {
    super.loadAd()
    mrecAd = BannerAd(requireContext(), placementId, BannerAdSize.VUNGLE_MREC).apply {
      adListener = this@MrecFragment
      load()
    }
  }

  override fun playAd() {
    super.playAd()
    if (mrecAd?.canPlayAd() == true) {
      mrecAd?.let {
        val bannerView: BannerView? = mrecAd?.getBannerView()
        val params = FrameLayout.LayoutParams(
          FrameLayout.LayoutParams.WRAP_CONTENT,
          FrameLayout.LayoutParams.WRAP_CONTENT,
          Gravity.CENTER_HORIZONTAL
        )
        binding.adContainer.addView(bannerView, params)
      }
      bannerDimensionUi()
    }
  }

  override fun destroyAd() {
    super.destroyAd()
    binding.btnDestroyAd.setOnClickListener {
      binding.adContainer.removeAllViews()
      mrecAd?.finishAd()
      mrecAd = null
    }
  }

  override fun onAdLoaded(baseAd: BaseAd) {
    super.onAdLoaded(baseAd)
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
    mrecAd?.adListener = null
    mrecAd = null
  }
}