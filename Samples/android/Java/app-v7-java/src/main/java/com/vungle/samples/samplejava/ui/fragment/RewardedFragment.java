package com.vungle.samples.samplejava.ui.fragment;

import android.os.Bundle;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.vungle.ads.AdConfig;
import com.vungle.ads.BaseAd;
import com.vungle.ads.RewardedAd;
import com.vungle.ads.RewardedAdListener;
import com.vungle.ads.VungleError;
import com.vungle.samples.samplejava.R;

public class RewardedFragment extends AdExperienceFragment implements RewardedAdListener {

    private RewardedAd rewardedAd;

    public RewardedFragment() {
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        _binding.lbOnRewarded.setVisibility(View.VISIBLE);
    }

    @Override
    protected void destroyAd() {
        super.destroyAd();
    }

    @Override
    protected void playAd() {
        super.playAd();
        if (rewardedAd != null && rewardedAd.canPlayAd()) {
            rewardedAd.play(requireContext());
        }
    }

    @Override
    protected void loadAd() {
        super.loadAd();
        rewardedAd = new RewardedAd(requireActivity(), placementId, new AdConfig());
        rewardedAd.setAdListener(this);
        rewardedAd.load("");
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

    @Override
    public void onAdRewarded(@NonNull BaseAd baseAd) {
        setTextColor(_binding.lbOnRewarded, R.color.black);

    }
}
