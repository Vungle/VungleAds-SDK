package com.vungle.samples.samplekotlin

import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.widget.Toast
import androidx.core.view.isVisible
import com.vungle.samples.samplekotlin.databinding.LayoutNativeAdBinding
import com.vungle.samples.samplekotlin.ui.AdExperienceFragment
import com.vungle.samples.samplekotlin.utils.extensions.show
import com.vungle.ads.NativeAd
import com.vungle.ads.NativeAdListener
import com.vungle.ads.BaseAd
import com.vungle.ads.VungleError
import com.vungle.ads.nativead.NativeVideoListener
import com.vungle.samples.samplekotlin.utils.extensions.blackText
import com.vungle.samples.samplekotlin.utils.extensions.lightGrayText

class NativeAdFragment : AdExperienceFragment(), NativeAdListener {

    private var nativeAd: NativeAd? = null

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        binding.nativeVideoLog.visibility = View.VISIBLE
        configureUi()
    }

    override fun loadAd() {
        super.loadAd()
        nativeAd = NativeAd(requireContext(), placementId).apply {
            adOptionsPosition = NativeAd.TOP_LEFT
            videoOptions.apply {
                startMuted = true
            }
        }.apply {
            adListener = this@NativeAdFragment
            load()
        }
    }

    override fun resetCallbackLabelColor() {
        super.resetCallbackLabelColor()
        binding.videoPlayTV.lightGrayText()
        binding.videoPauseTV.lightGrayText()
        binding.videoEndTV.lightGrayText()
        binding.videoMuteTV.lightGrayText()
        binding.videoUnmuteTV.lightGrayText()
    }

    override fun playAd() {
        super.playAd()
        populateNativeAdView()
    }

    private fun populateNativeAdView() {
        if (nativeAd?.canPlayAd() == false) {
            Toast.makeText(requireContext(), "Can not display native ad", Toast.LENGTH_SHORT).show()
            return
        }
        nativeAd?.let { nativeAd ->
            val layout = LayoutNativeAdBinding.inflate(LayoutInflater.from(requireContext()))
            with(layout) {
                binding.adContainer.removeAllViews()

                if (nativeAd.hasVideoContent()) {
                    pnlVideoAd.setNativeVideoListener(object : NativeVideoListener {

                        override fun onVideoPlay() {
                            Log.d(TAG, "onVideoPlay")
                            binding.videoPlayTV.blackText()
                        }

                        override fun onVideoPause() {
                            Log.d(TAG, "onVideoPause")
                            binding.videoPauseTV.blackText()
                        }

                        override fun onVideoEnd() {
                            Log.d(TAG, "onVideoEnd")
                            binding.videoEndTV.blackText()
                        }

                        override fun onVideoMute() {
                            Log.d(TAG, "onVideoMute")
                            binding.videoMuteTV.blackText()
                        }

                        override fun onVideoUnmute() {
                            Log.d(TAG, "onVideoUnmute")
                            binding.videoUnmuteTV.blackText()
                        }
                    })
                }

                val clickableViews = mutableListOf(imgAdIcon, pnlVideoAd, btnAdCta)
                nativeAd.registerViewForInteraction(
                    root, pnlVideoAd, imgAdIcon, clickableViews
                )

                lbAdTitle.text = nativeAd.getAdTitle()
                lbAdBody.text = nativeAd.getAdBodyText()
                lbAdRating.text = String.format("Rating: %s", nativeAd.getAdStarRating())
                lbAdSponsor.text = nativeAd.getAdSponsoredText()
                btnAdCta.text = nativeAd.getAdCallToActionText()
                btnAdCta.isVisible = nativeAd.hasCallToAction()

                binding.apply {
                    adContainer.show()
//            txtAdWidth.gone()
//            txtAdHeight.gone()
                }

                binding.adContainer.addView(root)
            }
        }
    }

    override fun destroyAd() {
        super.destroyAd()
        binding.adContainer.removeAllViews()
        nativeAd?.unregisterView()
        nativeAd = null
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

    override fun onDestroyView() {
        super.onDestroyView()
        nativeAd?.adListener = null
        nativeAd = null
    }
}