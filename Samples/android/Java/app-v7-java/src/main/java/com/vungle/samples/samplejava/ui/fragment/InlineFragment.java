package com.vungle.samples.samplejava.ui.fragment;

import android.os.Bundle;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.vungle.ads.BannerAdListener;
import com.vungle.ads.BaseAd;
import com.vungle.ads.VungleAdSize;
import com.vungle.ads.VungleBannerView;
import com.vungle.ads.VungleError;
import com.vungle.samples.samplejava.R;

public class InlineFragment extends AdExperienceFragment implements BannerAdListener {

    private VungleBannerView bannerAd;

    public InlineFragment() {

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
        if (bannerAd != null) {
            bannerAd.finishAd();
            bannerAd.setAdListener(null);
            bannerAd = null;
        }
    }

    @Override
    protected void playAd() {
        super.playAd();
    }

    @Override
    protected void loadAd() {
        super.loadAd();
        VungleAdSize vngAdSize = VungleAdSize.getAdSizeWithWidthAndHeight( 300, 200 );
        bannerAd = new VungleBannerView(requireActivity(), placementId, vngAdSize);
        bannerAd.setAdListener(this);
        bannerAd.load("");

        ViewGroup.LayoutParams params = new FrameLayout.LayoutParams(
            FrameLayout.LayoutParams.WRAP_CONTENT,
            FrameLayout.LayoutParams.WRAP_CONTENT,
            Gravity.CENTER_HORIZONTAL);
        _binding.adContainer.addView(bannerAd, params);
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
