package com.vungle.samples.samplekotlin.ui

import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.activity.OnBackPressedCallback
import androidx.fragment.app.Fragment
import androidx.navigation.fragment.findNavController
import com.vungle.samples.samplekotlin.utils.extensions.blackText
import com.vungle.samples.samplekotlin.utils.extensions.lightGrayText
import com.vungle.ads.BaseAd
import com.vungle.ads.InterstitialAdListener
import com.vungle.ads.RewardedAdListener
import com.vungle.ads.VungleError
import com.vungle.samples.samplekotlin.R
import com.vungle.samples.samplekotlin.databinding.FragmentAdexperienceBinding

open class AdExperienceFragment : Fragment(R.layout.fragment_adexperience), InterstitialAdListener, RewardedAdListener {

  protected open val TAG = "VungleAds"

  private var _binding: FragmentAdexperienceBinding? = null
  val binding get() = _binding!!
  lateinit var placementId: String

  override fun onCreateView(
    inflater: LayoutInflater,
    container: ViewGroup?,
    savedInstanceState: Bundle?
  ): View? {
    _binding = FragmentAdexperienceBinding.inflate(inflater, container, false)
    placementId = arguments?.getString("placement_id").toString()
    return binding.root
  }

  override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
      binding.nativeVideoLog.visibility = View.GONE
    binding.btnLoadAd.setOnClickListener {
      resetCallbackLabelColor()
      loadAd()
    }
    binding.btnPlayAd.setOnClickListener {
      playAd()
    }
    binding.btnDestroyAd.setOnClickListener {
      destroyAd()
    }
    requireActivity().onBackPressedDispatcher.addCallback(
      viewLifecycleOwner,
      object : OnBackPressedCallback(
        true
      ) {
        override fun handleOnBackPressed() {
          findNavController().navigateUp()
        }
      })
  }

  override fun onAdLoaded(baseAd: BaseAd) {
    Log.d(TAG, "adLoaded")
    binding.lbAdLoaded.blackText()
    binding.btnPlayAd.isEnabled = true
  }

  override fun onAdStart(baseAd: BaseAd) {
    Log.d(TAG, "adStart")
    binding.lbAdStart.blackText()
    binding.btnPlayAd.isEnabled = false
  }

  override fun onAdImpression(baseAd: BaseAd) {
    Log.d(TAG, "adImpression")
    binding.lbAdImpression.blackText()
  }

  override fun onAdEnd(baseAd: BaseAd) {
    Log.d(TAG, "adEnd")
    binding.lbAdEnd.blackText()
  }

  override fun onAdClicked(baseAd: BaseAd) {
    Log.d(TAG, "adClick")
    binding.lbAdClick.blackText()
  }

  override fun onAdRewarded(baseAd: BaseAd) {
    Log.d(TAG, "adRewarded")
    binding.lbOnRewarded.blackText()
  }

  override fun onAdLeftApplication(baseAd: BaseAd) {
    Log.d(TAG, "onAdLeftApplication")
    binding.lbOnAdLeftApplication.blackText()
  }

  override fun onAdFailedToLoad(baseAd: BaseAd, adError: VungleError) {
    val exceptionCode = adError.code
    val localizedMessage = adError.localizedMessage
    val errorMessage = "onAdFailedToLoad - $exceptionCode $localizedMessage"
    Log.d(TAG, errorMessage)
    binding.lbError.apply {
      blackText()
      text = errorMessage
    }
  }

  override fun onAdFailedToPlay(baseAd: BaseAd, adError: VungleError) {
    val exceptionCode = adError.code
    val localizedMessage = adError.localizedMessage
    val errorMessage = "onAdFailedToPlay - $exceptionCode $localizedMessage"
    Log.d(TAG, errorMessage)
    binding.lbError.apply {
      blackText()
      text = errorMessage
    }
  }

  protected open fun loadAd() {
    Log.d(TAG, "Load ad")
  }

  protected open fun playAd() {
    Log.d(TAG, "Play ad")
  }

  protected open fun destroyAd() {
    Log.d(TAG, "Destroy ad")
  }

  open fun resetCallbackLabelColor() {
    binding.adContainer.removeAllViews()
    binding.lbAdLoaded.lightGrayText()
    binding.lbAdStart.lightGrayText()
    binding.lbAdImpression.lightGrayText()
    binding.lbAdClick.lightGrayText()
    binding.lbOnAdLeftApplication.lightGrayText()
    binding.lbOnRewarded.lightGrayText()
    binding.lbAdEnd.lightGrayText()
    binding.lbError.lightGrayText()
    binding.lbError.setText(R.string.error)
  }

  override fun onDestroyView() {
    super.onDestroyView()
    _binding = null
  }
}