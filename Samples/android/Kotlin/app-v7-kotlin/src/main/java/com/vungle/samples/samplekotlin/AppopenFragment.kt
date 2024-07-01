package com.vungle.samples.samplekotlin

import android.os.Bundle
import android.view.View
import com.vungle.samples.samplekotlin.ui.AdExperienceFragment
import com.vungle.ads.AdConfig
import com.vungle.ads.BaseAd
import com.vungle.ads.InterstitialAd
import com.vungle.ads.InterstitialAdListener
import com.vungle.ads.VungleError

class AppopenFragment : AdExperienceFragment(), InterstitialAdListener {

  private var interstitialAd: InterstitialAd? = null

  override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
    super.onViewCreated(view, savedInstanceState)

    configureUi()
  }

  override fun loadAd() {
    super.loadAd()

    interstitialAd = InterstitialAd(requireContext(), placementId, AdConfig().apply {
      adOrientation = AdConfig.AUTO_ROTATE
    }).apply {
      adListener = this@AppopenFragment
      load()
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

  override fun playAd() {
    super.playAd()
    if (interstitialAd?.canPlayAd() == true) {
      interstitialAd?.play(requireContext())
    }
  }


  private fun configureUi() {
    binding.lbPlacementId.text = placementId
  }

  override fun onDestroyView() {
    super.onDestroyView()
    interstitialAd?.adListener = null
    interstitialAd = null
  }
}