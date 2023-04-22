package com.vungle.samples.samplejava.ui.fragment;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.content.ContextCompat;
import androidx.fragment.app.Fragment;

import com.vungle.samples.samplejava.R;
import com.vungle.samples.samplejava.databinding.FragmentAdexperienceBinding;

public class AdExperienceFragment extends Fragment {

    protected String placementId;

    protected FragmentAdexperienceBinding _binding = null;

    public AdExperienceFragment() {
    }

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        _binding = FragmentAdexperienceBinding.inflate(inflater, container, false);
        if (getArguments() != null) {
            placementId = getArguments().getString("placement_id");
        }
        return _binding.getRoot();
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);

        _binding.btnLoadAd.setOnClickListener(view1 -> {
            AdExperienceFragment.this.resetCallbackLabelColor();
            AdExperienceFragment.this.loadAd();
        });
        _binding.btnPlayAd.setOnClickListener(view12 -> AdExperienceFragment.this.playAd());
        _binding.btnDestroyAd.setOnClickListener(view13 -> AdExperienceFragment.this.destroyAd());
        _binding.lbPlacementId.setText(placementId);
    }

    protected void destroyAd() {
    }

    protected void playAd() {

    }

    protected void loadAd() {

    }

    private void resetCallbackLabelColor() {
        _binding.adContainer.removeAllViews();
        setTextColor(_binding.lbAdLoaded, R.color.lightGray);
        setTextColor(_binding.lbAdStart, R.color.lightGray);
        setTextColor(_binding.lbAdImpression, R.color.lightGray);
        setTextColor(_binding.lbAdClick, R.color.lightGray);
        setTextColor(_binding.lbOnAdLeftApplication, R.color.lightGray);
        setTextColor(_binding.lbOnRewarded, R.color.lightGray);
        setTextColor(_binding.lbAdEnd, R.color.lightGray);
        setTextColor(_binding.lbError, R.color.lightGray);

        _binding.lbError.setText(R.string.error);
    }

    protected void setTextColor(TextView textView, int color) {
        textView.setTextColor(ContextCompat.getColor(requireActivity(), color));
    }
}
