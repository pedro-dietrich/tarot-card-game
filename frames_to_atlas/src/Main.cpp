#include <iostream>
#include <filesystem>
#include <vector>

#define STB_IMAGE_IMPLEMENTATION
#include <stb_image.h>
#define STB_IMAGE_WRITE_IMPLEMENTATION
#include <stb_image_write.h>

namespace fs = std::filesystem;

struct Dimensions
{
    int width;
    int height;

    constexpr int size() const { return width * height; }
};

Dimensions loadFrames(const std::string& folderPath, std::vector<unsigned char*>& frames);
void copyFramesToAtlas
(
    const std::vector<unsigned char*>& frames,
    std::vector<unsigned char>& atlasData,
    const Dimensions& frameDim
);
void saveAtlas
(
    const std::string& folderPath,
    Dimensions atlasImageDim,
    const std::vector<unsigned char>& atlasData
);

constexpr int atlasColumnCount = 6;
constexpr int atlasRowCount = 4;
constexpr int frameCount = atlasColumnCount * atlasRowCount;
constexpr int atlasChannels = 4;

int main(int argc, char** argv)
{
    if(argc != 2)
    {
        std::cerr << "Provide the path to the folder containing the 24 frames." << '\n'
            << "Usage: " << argv[0] << " <folder_path>/\n";
        return 1;
    }
    const std::string folderPath = argv[1];

    std::vector<unsigned char*> frames;

    const Dimensions frameDim = loadFrames(folderPath, frames);

    Dimensions atlasImageDim
    {
        frameDim.width * atlasColumnCount,
        frameDim.height * atlasRowCount
    };
    std::vector<unsigned char> atlasData(atlasImageDim.size() * atlasChannels, 0);

    copyFramesToAtlas(frames, atlasData, frameDim);

    saveAtlas(folderPath, atlasImageDim, atlasData);

    for(unsigned char* img: frames)
        stbi_image_free(img);

    return 0;
}

Dimensions loadFrames(const std::string& folderPath, std::vector<unsigned char*>& frames)
{
    Dimensions frameDim{0, 0};

    for(int i = 0; i < frameCount; i++)
    {
        std::string filename = folderPath + "/" + std::to_string(i) + ".png";

        int width = 0;
        int height = 0;
        int frameChannels = 0;

        unsigned char* data = stbi_load(filename.c_str(), &width, &height, &frameChannels, atlasChannels);
        if(!data)
        {
            std::cerr << "Failed to load image: " << filename << std::endl;
            for(unsigned char* img: frames)
                stbi_image_free(img);
            std::runtime_error("Failed to load image.");
        }

        if(i == 0)
        {
            frameDim.width = width;
            frameDim.height = height;
        }
        else if(width != frameDim.width || height != frameDim.height)
        {
            std::cerr << "Image sizes do not match: " << filename << std::endl;
            for(unsigned char* img: frames)
                stbi_image_free(img);
            stbi_image_free(data);

            std::runtime_error("Frame images with different dimensions are not supported.");
        }

        frames.push_back(data);
    }

    std::cout << "Frames loaded." << std::endl;

    return frameDim;
}

void copyFramesToAtlas
(
    const std::vector<unsigned char*>& frames,
    std::vector<unsigned char>& atlasData,
    const Dimensions& frameDim
)
{
    const int atlasImageWidth = frameDim.width * atlasColumnCount;

    for(int frameIndex = 0; frameIndex < frameCount; frameIndex++)
    {
        const int col = frameIndex % atlasColumnCount;
        const int row = frameIndex / atlasColumnCount;

        for(int y = 0; y < frameDim.height; y++)
        {
            const int atlasY = row * frameDim.height + y;

            for(int x = 0; x < frameDim.width; x++)
            {
                const int atlasX = col * frameDim.width + x;

                const int atlasImageIndex = (atlasY * atlasImageWidth + atlasX) * atlasChannels;
                const int frameImageIndex = (y * frameDim.width + x) * atlasChannels;

                for(int c = 0; c < atlasChannels; c++)
                    atlasData[atlasImageIndex + c] = frames[frameIndex][frameImageIndex + c];
            }
        }
    }
    std::cout << "Frames copied to atlas." << std::endl;
}

void saveAtlas
(
    const std::string& folderPath,
    Dimensions atlasImageDim,
    const std::vector<unsigned char>& atlasData
)
{
    const std::string outputPath = folderPath + "atlas.png";
    const int result = stbi_write_png
    (
        outputPath.c_str(),
        atlasImageDim.width, atlasImageDim.height, atlasChannels,
        atlasData.data(),
        atlasImageDim.width * atlasChannels
    );

    if(result)
        std::cout << "Atlas successfully saved to " << outputPath << std::endl;
    else
        std::cerr << "Failed to save atlas image." << std::endl;
}
