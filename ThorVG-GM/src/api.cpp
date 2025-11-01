// Copyright (c) 2025 Benjamin Halko

#include <thorvg.h>

#ifdef _WIN32
    #define GM_API extern "C" __declspec(dllexport)
#else
    #define GM_API extern "C"
#endif

#define CHECK(result) if (result != tvg::Result::Success) return static_cast<double>(result)

struct GM_Data {
    uint32_t width;
    uint32_t height;
    uint32_t duration;
    uint32_t totalFrames;

    tvg::SwCanvas* canvas;
    tvg::Animation* animation;
};

GM_API double tvg_init() {
    return static_cast<double>(tvg::Initializer::init(0));
}

GM_API double tvg_term() {
    return static_cast<double>(tvg::Initializer::term());
}

GM_API double tvg_create(
    GM_Data* data,
    const char* picture_data,
    double picture_data_size
) {
    data->canvas = tvg::SwCanvas::gen();
    data->animation = tvg::Animation::gen();

    // Load picture
    const auto picture = data->animation->picture();
    CHECK(picture->load(picture_data, picture_data_size, ""));
    CHECK(data->canvas->push(picture));

    // Load picture data
    float width, height;
    CHECK(picture->size(&width, &height));
    data->width = static_cast<uint32_t>(width);
    data->height = static_cast<uint32_t>(height);
    data->duration = static_cast<uint32_t>(data->animation->duration());
    data->totalFrames = static_cast<uint32_t>(data->animation->totalFrame());

    return 0;
}

GM_API void tvg_destory(GM_Data* data) {
    delete(data->animation);
    delete(data->canvas);
}

GM_API double tvg_set_target(GM_Data* data, uint32_t* buffer, double width, double height) {
    CHECK(data->animation->picture()->size(width, height));

    CHECK(data->canvas->target(
        buffer,
        width,
        width,
        height,
        tvg::ColorSpace::ABGR8888S
    ));

    return 0;
}

GM_API double tvg_draw(
    GM_Data* data,
    double clear
) {
    CHECK(data->canvas->update());
    CHECK(data->canvas->draw(clear));
    CHECK(data->canvas->sync());

    return 0;
}

GM_API double tvg_set_frame(GM_Data* data, double frame) {
    CHECK(data->animation->frame(frame));

    return 0;
}
