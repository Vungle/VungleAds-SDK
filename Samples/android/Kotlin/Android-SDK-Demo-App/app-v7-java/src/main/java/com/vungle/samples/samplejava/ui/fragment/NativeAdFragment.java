package com.vungle.samples.samplejava.ui.fragment;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.vungle.ads.BaseAd;
import com.vungle.ads.NativeAd;
import com.vungle.ads.NativeAdListener;
import com.vungle.ads.VungleError;
import com.vungle.samples.samplejava.R;
import com.vungle.samples.samplejava.databinding.LayoutNativeAdBinding;

import java.util.ArrayList;
import java.util.List;

public class NativeAdFragment extends AdExperienceFragment implements NativeAdListener {

    private NativeAd nativeAd;

    public NativeAdFragment() {

    }

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        return super.onCreateView(inflater, container, savedInstanceState);
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        configureUI();
    }

    private void configureUI() {
        _binding.groupBanner.setVisibility(View.VISIBLE);
        _binding.btnDestroyAd.setVisibility(View.VISIBLE);
        _binding.btnDestroyAd.setEnabled(false);
        setTextColor(_binding.btnDestroyAd, R.color.lightGray);

    }

    @Override
    protected void destroyAd() {
        super.destroyAd();
        if (nativeAd != null) {
            _binding.adContainer.removeAllViews();
            nativeAd.setAdListener(null);
            nativeAd = null;
        }
    }

    @Override
    protected void playAd() {
        super.playAd();
        populateNativeAdView();

    }

    private void populateNativeAdView() {
        if (nativeAd != null && nativeAd.canPlayAd()) {
            _binding.adContainer.removeAllViews();
            @NonNull LayoutNativeAdBinding layout = LayoutNativeAdBinding.inflate(LayoutInflater.from(requireContext()));
            List<View> clickableViews = new ArrayList<>();
            clickableViews.add(layout.imgAdIcon);
            clickableViews.add(layout.pnlVideoAd);
            clickableViews.add(layout.btnAdCta);
            nativeAd.registerViewForInteraction(layout.getRoot(), layout.pnlVideoAd, layout.imgAdIcon, clickableViews);

            layout.lbAdTitle.setText(nativeAd.getAdTitle());
            layout.lbAdBody.setText(nativeAd.getAdBodyText());
            layout.lbAdRating.setText(String.format("Rating: %s", nativeAd.getAdStarRating()));
            layout.lbAdSponsor.setText(nativeAd.getAdSponsoredText());
            layout.btnAdCta.setText(nativeAd.getAdCallToActionText());
            layout.btnAdCta.setVisibility(nativeAd.hasCallToAction() ? View.VISIBLE : View.GONE);

            _binding.adContainer.addView(layout.getRoot());
            _binding.adContainer.setVisibility(View.VISIBLE);
        }
    }

    @Override
    protected void loadAd() {
        super.loadAd();
        nativeAd = new NativeAd(requireActivity(), placementId);
        nativeAd.setAdListener(this);
        nativeAd.load("");
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
        _binding.btnDestroyAd.setEnabled(true);
        setTextColor(_binding.btnDestroyAd, R.color.black);

    }
}
