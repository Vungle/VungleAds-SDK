package com.vungle.samples.samplekotlin

import android.os.Bundle
import android.view.View
import com.vungle.samples.samplekotlin.ui.AdExperienceFragment
import com.vungle.samples.samplekotlin.utils.extensions.show
import com.vungle.ads.AdConfig
import com.vungle.ads.BaseAd
import com.vungle.ads.RewardedAd
import com.vungle.ads.RewardedAdListener
import com.vungle.ads.VungleError

class RewardedFragment : AdExperienceFragment(), RewardedAdListener {

    private var rewardedAd: RewardedAd? = null

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        configureUi()
    }

    override fun loadAd() {
        super.loadAd()
        rewardedAd = RewardedAd(requireContext(), placementId, AdConfig().apply {
            adOrientation = AdConfig.LANDSCAPE
        }).apply {
            adListener = this@RewardedFragment
            setUserId("VungleTestUser")
            load()
        }
    }

    override fun playAd() {
        super.playAd()
        if (rewardedAd?.canPlayAd() == true) {
            rewardedAd?.play(requireContext())
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

    override fun onAdRewarded(baseAd: BaseAd) {
        super.onAdRewarded(baseAd)
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
        binding.lbPlacementId.text = placementId
        binding.lbOnRewarded.show()
    }

    override fun onDestroyView() {
        super.onDestroyView()
        rewardedAd?.adListener = null
        rewardedAd = null
    }
}