package com.vungle.samples.samplejava.ui.fragment;

import androidx.annotation.NonNull;
import com.vungle.ads.AdConfig;
import com.vungle.ads.BaseAd;
import com.vungle.ads.InterstitialAd;
import com.vungle.ads.InterstitialAdListener;
import com.vungle.ads.VungleError;
import com.vungle.samples.samplejava.R;

public class AppopenFragment extends AdExperienceFragment implements InterstitialAdListener {

    private InterstitialAd interstitialAd;

    public AppopenFragment() {
        // doesn't do anything special
    }

    @Override
    protected void playAd() {
        super.playAd();
        if (interstitialAd != null && interstitialAd.canPlayAd()) {
            interstitialAd.play(requireContext());
        }
    }

    @Override
    protected void loadAd() {
        super.loadAd();
        interstitialAd = new InterstitialAd(requireActivity(), placementId, new AdConfig());
        interstitialAd.setAdListener(this);
        interstitialAd.load("");
    }

    @Override
    public void onAdClicked(@NonNull BaseAd baseAd) {
        setTextColor(_binding.lbAdClick, R.color.black);
    }

    @Override
    public void onAdEnd(@NonNull BaseAd baseAd) {
        setTextColor(_binding.lbAdEnd, R.color.black);
    }

    @Override
    public void onAdFailedToLoad(@NonNull BaseAd baseAd, @NonNull VungleError vungleError) {
        setTextColor(_binding.lbError, R.color.black);
        _binding.lbError.setText(vungleError.getErrorMessage());
    }

    @Override
    public void onAdFailedToPlay(@NonNull BaseAd baseAd, @NonNull VungleError vungleError) {
        setTextColor(_binding.lbError, R.color.black);
        _binding.lbError.setText(vungleError.getErrorMessage());
    }

    @Override
    public void onAdImpression(@NonNull BaseAd baseAd) {
        setTextColor(_binding.lbAdImpression, R.color.black);
    }

    @Override
    public void onAdLeftApplication(@NonNull BaseAd baseAd) {
        setTextColor(_binding.lbOnAdLeftApplication, R.color.black);
    }

    @Override
    public void onAdLoaded(@NonNull BaseAd baseAd) {
        setTextColor(_binding.lbAdLoaded, R.color.black);
        _binding.btnPlayAd.setEnabled(true);
        setTextColor(_binding.btnPlayAd, R.color.black);
    }

    @Override
    public void onAdStart(@NonNull BaseAd baseAd) {
        setTextColor(_binding.lbAdStart, R.color.black);
        _binding.btnPlayAd.setEnabled(false);
        setTextColor(_binding.btnPlayAd, R.color.lightGray);
    }
}
